//
//  BRTLocationManager.m
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

#import "BRTLocationManager.h"
#import "BRTLog.h"

@interface BRTLocationManager () <CLLocationManagerDelegate>

//@property (nonatomic, strong) CLLocationManager *locationManager;
@property (atomic, strong, readwrite) CLLocation *location;
@property (atomic, strong) NSMutableArray *completions;
@property (atomic) BOOL requestingLocation;

@end


@implementation BRTLocationManager

static const NSTimeInterval UsePreviousLocationThreshold = 60;

- (id)init {
    self = [super init];
    if (self) {
        _completions = [[NSMutableArray alloc] init];
        _location = nil;
        _desiredAccuracy = kCLLocationAccuracyBest;
        _requestingLocation = NO;
    }
    return self;
}

- (void)setDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy {
    self.locationManager.desiredAccuracy = desiredAccuracy;
    self->_desiredAccuracy = desiredAccuracy;
}


- (void)requestLocationWithCompletion:(BRTLocationRequestCompletion)completion {
    myprintf("r");
        // check if the last known location was within the threshold
        if (self.location && -[self.location.timestamp timeIntervalSinceNow] < UsePreviousLocationThreshold) {
            myprintf(" -> ");
            completion(self.location, nil);
            return;
        }
        
        // check if location is already being requested
    @synchronized(self.completions) {
        [self.completions addObject:completion];
    }
        if (!self.requestingLocation) {
            self.requestingLocation = YES;
            myprintf(" *re");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![NSThread isMainThread]) {
                    printf("%s not main thread\n",__FUNCTION__);
                }

                [self->_locationManager requestLocation];
                myprintf("q* ");

            });
       }
}


#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [BRTLog logDebug:BRTLog.locationManager format:@"✅ Location updated"];
    self.location = locations.firstObject;
    myprintf("@");
    self.requestingLocation = NO;

    @synchronized(self.completions) {
        for (BRTLocationRequestCompletion completion in self.completions) {
            if (completion != nil) {
                myprintf(".");
                completion(self.location, nil);
            }
        }
        [self.completions removeAllObjects];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    myprintf(" -f- ");
    [BRTLog logError:BRTLog.locationManager format:@"❌ Failed with error - %@", error.localizedDescription];
    self.requestingLocation = NO;
    for (BRTLocationRequestCompletion completion in self.completions) {
        if (completion != nil) {
            completion(nil, error);
        }
    }
    [self.completions removeAllObjects];
}


@end
