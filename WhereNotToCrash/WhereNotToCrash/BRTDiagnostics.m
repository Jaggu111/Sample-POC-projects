//  BRTDiagnostics.m
//  BrightDiagnostics
//
// **********************************************************************************
// *                                                                                *
// *    Copyright (c) 2018 AT&T Intellectual Property. ALL RIGHTS RESERVED          *
// *                                                                                *
// *    This code is licensed under a personal license granted to you by AT&T.      *
// *                                                                                *
// *    All use must comply with the terms of such license. No unauthorized use,    *
// *    copying, modifying or transfer is permitted without the express permission  *
// *    of AT&T. If you do not have a copy of the license, you may obtain a copy    *
// *    of such license from AT&T.                                                  *
// *                                                                                *
// **********************************************************************************
//

#import "BRTDiagnostics.h"
#import "BrightDiagnostics.h"
#import "BRTUtility.h"
#import "BRTMetricCollector.h"
#import "BRTMetricUtility.h"
#import "BRTPackageGenerator.h"
#import "BRTPackageManager.h"
#import "BRTPackageUploader.h"
#import "BRTSignificantLocationChange.h"
#import "BRTTimer.h"
#import "BRTRestrictions.h"
#import "BRTLocationManager.h"
#import "BRTLog.h"

// number of seconds to subtract from UTC time to convert to CDMA/GPS time
#define CDMA_TIME_OFFSET (315964800 /* the epoch difference in seconds */ - 18 /* leap seconds */)

//TODO: refactor later
@interface BRTPackageUploader (Testable)
+ (void)setUploadsServer:(NSString *)URLString;
@end

@interface BRTDiagnostics () <BRTSignificantLocationChangeMonitorDelegate, BRTTimerDelegate>

@property (atomic) BOOL isInitialized;
@property (nonatomic, strong) NSDictionary *ourMetrics;
@property (nonatomic, strong) BRTSignificantLocationChange *significantChangeMonitor;
@property (nonatomic, strong) BRTTimer *timerMonitor;
@property (nonatomic, strong) BRTPackageUploader *uploader;
@property (nonatomic, strong) BRTMetricCollector *metricCollector;
@property (nonatomic, strong) BRTRestrictions *restrictions;

@property (atomic) BOOL _sdkEnabled;
@property (atomic) BOOL _realTimeUploads;


@property (atomic) BOOL observersSetup;
@property (atomic) uint64_t lastTime;
@property (atomic) BOOL collectingMetrics;
@property (atomic) BOOL uploadingMetrics;

@property (nonatomic, strong) dispatch_queue_t action_queue;
@property (nonatomic, strong) dispatch_queue_t metricQueue;


@end

@implementation BRTDiagnostics


#pragma mark - initialization

/// Shared singleton instance of BRTDiagnostics
+ (instancetype)shared {
    static BRTDiagnostics *_sharedInstance = nil;
    static dispatch_once_t _once_token = 0;
    dispatch_once(&_once_token, ^{
        _sharedInstance = [[BRTDiagnostics alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isInitialized = NO;
        _lastTime = 0;
        _ourMetrics = nil;
        _observersSetup = NO;
        __realTimeUploads = YES;
        __sdkEnabled = true;
        _restrictions = [[BRTRestrictions alloc] init];
        
        _uploader = [[BRTPackageUploader alloc] init];
        
        _metricCollector = [[BRTMetricCollector alloc] init];
        
        _packageManager = [[BRTPackageManager alloc] init];
        
        _significantChangeMonitor = [[BRTSignificantLocationChange alloc] init];
        _significantChangeMonitor.delegate = self;
        
        _timerMonitor = [[BRTTimer alloc] init];
        _timerMonitor.delegate = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_locationManager = [[BRTLocationManager alloc] init];
        });
        
        _action_queue = dispatch_queue_create("com.att.mobile.bdsdk.action", dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, 0));
        _metricQueue = dispatch_queue_create("com.att.mobile.bdsdk.metrics", dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_UTILITY, 0));

        
        // should be first thing ever on the action_queue
        // any other things queued here can rely on anything created or assigned here
        dispatch_sync(_action_queue, ^{
            // initialize dictionary of queued uploads
            
            // set list of metrics, future possible to get from app bundle
            self->_ourMetrics = @{
                                          @"AL57": @1,
                                          @"LC18": @1,
                                          @"MD01": @1,
                                          @"SS1W": @1,
                                          @"SS18": @1,
                                          @"SS1A": @1,
                                          @"SS1S": @1,
                                          @"SS2B": @1,
                                          @"SS2G": @1,
                                          @"SS2H": @1,
                                          @"WL31": @1,
                                          @"WL32": @1,
                                          };
            
            // bare minimum completed so able to use instance
            self->_isInitialized = YES;
            
        });
        
        // setup initial observers (must use instance while in init)
        [self setupEventObservers];
        [BRTLog logWithType:OS_LOG_DEFAULT type:OS_LOG_TYPE_DEBUG format:@"ℹ️ Using upload server: %@", self.uploader.uploadServerURL.absoluteString];
        // do anything that needs to be done outside of once
    }
    return self;
}



//+ (void)setSharedInsights:(BRTDiagnostics *)insights {
//    _once_token = 0;
//    _sharedInstance = nil;
//}

#pragma mark - observers

/*!
 *  @method setupEventObservers
 *  @abstract   template for methods which use action_queue
 *              convenience for cutting and pasting new threaded code
 *
 */
- (void)setupEventObservers {
    // ensure that there are no previously setup observers
    [self removeEventObservers];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(enterForeground:)
     name:UIApplicationDidBecomeActiveNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(enteredBackground:)
     name:UIApplicationDidEnterBackgroundNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(willResignActive:)
     name:UIApplicationWillResignActiveNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(willTerminate:)
     name:UIApplicationWillTerminateNotification
     object:nil];
    
    // track the status of notification observers enabled
    self.observersSetup = YES;
}

/*!
 *  @method enterForeground
 *  @abstract   perform anything we need to do
 *              when entering the foreground
 *              this method is called when initially starting
 *              and when re-entering the foreground from the background
 *
 */
- (void)enterForeground:(NSNotification *)notification {
    // check for any package uploads on app start, or return to foreground
    self.applicationState = [UIApplication sharedApplication].applicationState;
    // queue any existing packages for upload
    [self.uploader uploadAnyPackages];
}

- (void)enteredBackground:(NSNotification *)notification {
    self.applicationState = [UIApplication sharedApplication].applicationState;
}

/*!
 *  @method willResignActive
 *  @abstract   perform anything we want to do before entering the background
 *              such as queuing any waiting packages for upload
 *
 */
- (void)willResignActive:(NSNotification *)notification {
    // time to do (background) package uploading before entering the background
    self.applicationState = [UIApplication sharedApplication].applicationState;
        // queue any existing packages for upload
    [self.uploader uploadAnyPackages];
}

/*!
 *  @method willTerminate
 *  @abstract   perform any actions desired when going into background
 *              in particular, check for performing batched uploads
 *
 */
- (void)willTerminate:(NSNotification *)notification {
    // time to do (background) package uploading, before app terminates
    // completions may not occur until after app termination, and may be re-tried
    self.applicationState = [UIApplication sharedApplication].applicationState;
    [self.uploader uploadAnyPackages];

}


/*!
 *  @method removeEventObservers
 *  @abstract   template for methods which use action_queue
 *              convenience for cutting and pasting new threaded code
 *
 */
- (void)removeEventObservers {
    // track these are disabled
    self.observersSetup = NO;
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIApplicationDidBecomeActiveNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIApplicationWillResignActiveNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIApplicationWillTerminateNotification
     object:nil];
}

#pragma mark - Public Class methods

- (void)setSdkEnabled:(BOOL)sdkEnabled {
    if (sdkEnabled) {
        if (!self.observersSetup) {
            [self setupEventObservers];
        }
    }
    else {
        if (self.observersSetup) {
            [self removeEventObservers];
        }
#if TARGET_OS_IOS
        [self stopSignificantLocationChangeCollection];
#endif
        [self stopTimedCollection];
    }
    self._sdkEnabled = sdkEnabled;
}

- (BOOL)sdkEnabled {
    return self._sdkEnabled;
}

- (void)setRealTimeUploads:(BOOL)realTimeUploads {
    self._realTimeUploads = realTimeUploads;
    self.uploader.realTimeUploading = realTimeUploads;
}

- (BOOL)realTimeUploads {
    return self._realTimeUploads;
}

//TODO: check if this is used

//- (void)start {
//    if (![BrightDiagnostics sharedInsights].observersSetup) {
//        [sharedInstance setupEventObservers];
//    }
//
//    [self uploadAnyPackages];
//}

//- (void)stop {
//    // Note: We remove event observers when the SDK is disabled
//    //          but not for stopping the timers
//
//    // put stop action into the queue
//    dispatch_sync(self.action_queue, ^{
//        // nothing to do if not collecting metrics
//        // this is on the action queue, so start must be called first
//        if (collectingMetrics) {
//            collectingMetrics = NO;
//            NSArray *packages = [[BRTPackageUploader sharedInstance] packageFileList];
//            if (!packages || packages.count < 1) {
//                [BrightDiagnostics disableTimers];
//            }
//        }
//    });
//}


- (void)setDesiredLocationAccuracy:(CLLocationAccuracy)desiredLocationAccuracy {
    self.locationManager.desiredAccuracy = desiredLocationAccuracy;
}

- (CLLocationAccuracy)desiredLocationAccuracy {
    return self.locationManager.desiredAccuracy;
}

- (void)setCollectionRestrictionISOCountry:(NSString *)collectionRestrictionISOCountry {
    
    if (collectionRestrictionISOCountry == nil || [collectionRestrictionISOCountry isEqualToString:@""]) {
        self.restrictions.restrictedISOCountryCode = nil;
    }
    
    // check that string is 2 characters
    NSUInteger codeLength = 2;
    if (collectionRestrictionISOCountry.length != codeLength) {
        return;
    }
    
    NSRange whiteSpaceRange = [collectionRestrictionISOCountry rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    if (whiteSpaceRange.location != NSNotFound) {
        return;
    }
    
    // check for invalid characters
    NSCharacterSet *charactersToRemove = [[NSCharacterSet letterCharacterSet] invertedSet];
    NSRange range = [collectionRestrictionISOCountry rangeOfCharacterFromSet:charactersToRemove];
    if (range.location != NSNotFound) {
        return;
    }
    

    self.restrictions.restrictedISOCountryCode = [collectionRestrictionISOCountry uppercaseString];
    
    return;
}

- (NSString *)collectionRestrictionISOCountry {
    return self.restrictions.restrictedISOCountryCode;
}

#pragma mark Significant Location Change based collection

#if TARGET_OS_IOS
- (BOOL)startSignificantLocationChangeCollection {
    
    if (!self.sdkEnabled) {
        return false;
    }
    
    return self.significantChangeMonitor.startSignificantLocationChangeMonitoring;
}

- (void)stopSignificantLocationChangeCollection {
    [self.significantChangeMonitor stopSignificantLocationChangeMonitoring];
}
#endif

#pragma mark Timer collection

- (void)startTimedCollectionWithTimeInterval:(NSTimeInterval)interval {
    if (!self.sdkEnabled) {
        return;
    }
    
    if (interval <= 0) {
        return;
    }
    
    [self.timerMonitor startTimerWithTimeInterval:interval];
}

- (void)stopTimedCollection {
    // API facing must use sharedInsights the first time
    [self.timerMonitor stopTimer];
}

- (NSTimeInterval)timedCollectionInterval {
    return self.timerMonitor.timerInterval;
}

#pragma mark - private class methods

#pragma mark - collection

- (void)collectWithReason:(BRTDataCollectionReason)reason {
    dispatch_async(self.action_queue, ^{
        // check if sdk is enabled
        if (!self.sdkEnabled) {
            return;
        }
        
        // check for geographic restrictions
        [self.restrictions collectionAllowedWithCompletion:^(BOOL collectionAllowed) {
            if (collectionAllowed) {
                // actual collection and packaging of metrics async from setup
                dispatch_async(self.metricQueue, ^{
                    BRTPackageGenerator *package = [BRTPackageGenerator packageGeneratorWithTrigger: LIGHTWEIGHT_PACKAGE_TRIGGER];
                    [self.metricCollector collectMetricsUsing:package];
                    NSString *packageName = [BRTPackageGenerator createFileUsing:package manager:self.packageManager];
                    if (packageName) {
                        [self.uploader addPackageToUploadQueueWithPackageName:packageName];
                    }
                    
                    // if real-time uploads are being done, queue this
                    if (self.realTimeUploads) {
                        // queue any existing packages for upload
                        dispatch_async(self.action_queue, ^{
                            [self.uploader uploadPackageNamed:packageName];
                        });
                    }
                    
                    // Notify observers of data collection
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:BRTNotificationNameDataCollected object:nil userInfo:@{BRTDataCollectionReasonNotificationKey: @(reason)}];
                        if (self.collectionHandler) {
                            self.collectionHandler(reason);
                        }
                    });
                });
            }
        }];
    });
}

//#pragma mark - timers
//
///*!
// *  @method enableTimers
// *  @abstract   start timers for gathering and uploading metrics
// *
// */
//+ (void)enableTimers {
//    collectingMetrics = YES;
//    //MetricTimer = [NSTimer timerWithTimeInterval:gatherTime target:sharedInstance selector:@selector(gatherMetrics) userInfo:nil repeats:YES];
//    // [[NSRunLoop currentRunLoop] addTimer:MetricTimer forMode:NSDefaultRunLoopMode];
//
//    uploadingMetrics = YES;
//    //    UploadTimer = [NSTimer timerWithTimeInterval:uploadTime target:sharedInstance selector:@selector(uploadMetrics) userInfo:nil repeats:YES];
//    //    [[NSRunLoop currentRunLoop] addTimer:UploadTimer forMode:NSDefaultRunLoopMode];
//}
//
///*!
// *  @method disableTimers
// *  @abstract   stop timers for gathering and uploading metrics
// *
// */
//+ (void)disableTimers {
//    collectingMetrics = NO;
//    [MetricTimer invalidate];
//    uploadingMetrics = YES;
//    [UploadTimer invalidate];
//}

/*!
 *  @method gatherMetrics
 *  @abstract   gather metrics during each timer tick
 *
 */
- (void)gatherMetrics {
    // only do work while in foreground
    if ([BRTUtility isActive]) {
        
        if (self.collectingMetrics) {
            // code here to collect metrics
            [BrightDiagnostics collect];
        }
    }
}


#pragma mark - uploads

/*!
 *  @method setUpload:URLString
 *  @abstract   sets the upload URL to match the given string
 *              this method exposes an API call to the calling app
 *              to allow changing the upload/collector URL
 *
 *  @note       this method is internal use only and is only used
 *              by the alerts tool project to set the URL
 */
- (void)setUpload:(NSString *)URLString {
    [BRTPackageUploader setUploadsServer:URLString];
}



- (uint64_t)GPSTime {
    struct timespec ts;
    if (0 == clock_gettime(CLOCK_REALTIME, &ts)) {
        uint64_t const now = ((uint64_t)(ts.tv_sec - CDMA_TIME_OFFSET) * 1000) + ((uint64_t)(ts.tv_nsec) / 1000000);
        if (now > self.lastTime) self.lastTime = now;
    }
    return self.lastTime;
}

#pragma mark - BRTSignificantLocationChangeMonitor Delegate

- (void)significantLocationChangedWithLocation:(CLLocation *)location {
    [self collectWithReason:BRTDataCollectionReasonSignificantLocationChange];
}

#pragma mark - BRTTimer Delegate

- (void)timerDidFireWithTimeInterval:(NSTimeInterval)interval {
    [self collectWithReason:BRTDataCollectionReasonTimer];
}


#pragma mark - defaut Application and Stream properties

+ (void)setDefaultApplicationPropertiesWithSession:(NSString *)session
                                           account:(NSString *)account
                                              user:(NSString *)user {
    BRTDiagnostics.shared.session = session;
    BRTDiagnostics.shared.accountID = account;
    BRTDiagnostics.shared.userID = user;
}

+ (void)clearDefaultApplicationProperties {
    BRTDiagnostics.shared.session = nil;
    BRTDiagnostics.shared.accountID = nil;
    BRTDiagnostics.shared.userID = nil;
}

+ (void)setDefaultStreamPropertiesWith:(NSString *_Nullable)stream
                               network:(NSString *_Nullable)contentNetwork
                                  rate:(float)bitRate {
    BRTDiagnostics.shared.streamID = stream;
    BRTDiagnostics.shared.contentNetwork = contentNetwork;
    BRTDiagnostics.shared.bitRate = bitRate;
}

+ (void)clearDefaultStreamProperties {
    BRTDiagnostics.shared.streamID = nil;
    BRTDiagnostics.shared.contentNetwork = nil;
    BRTDiagnostics.shared.bitRate = 0.0;
}


@end

