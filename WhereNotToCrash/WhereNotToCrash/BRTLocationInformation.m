//  BRTLocationInformation.m
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

#import "BRTLocationInformation.h"
#import <SystemConfiguration/CaptiveNetwork.h>
//#import "BRTDiagnostics.h"
#import "BRTLocationManager.h"
#import "BRTLog.h"
//#import "NSMutableData+PackageSerializer.h"


// ifaddrs
#import <ifaddrs.h>
// IFF_* flags
#import <net/if.h>
// inet
#import <arpa/inet.h>


@interface BRTLocationInformation ()
@property (atomic, strong) CLLocation *currentLocation;
//@property (nonatomic, class, readonly)BRTRequestedLocationAccuracy requestedLocationAccuracy;
@end


@implementation BRTLocationInformation

static const int GPS_WAIT_TIME = 60;
static dispatch_group_t locationGroup = nil;
static BRTLocationManager *manager = nil;

+ (CLLocationManager *)locationManager {
    if (!manager) {
        if (![NSThread isMainThread]) {
            printf("%s not main thread\n",__FUNCTION__);
        }

        manager = [[BRTLocationManager alloc] init];
        manager.locationManager = [[CLLocationManager alloc] init];
        manager.locationManager.delegate = (id<CLLocationManagerDelegate> _Nullable)manager;
    }
    return manager.locationManager;
}

+ (void)setLocationManager:(CLLocationManager *)locationManager {
    static dispatch_once_t _once_token = 0;
    dispatch_once(&_once_token, ^{
        locationGroup = dispatch_group_create();
    });
    if (!manager) {
        manager = [[BRTLocationManager alloc] init];
    }
    if (locationManager
        && [locationManager isKindOfClass:[CLLocationManager class]]) {
        manager.locationManager = locationManager;
    }
    else {
        manager.locationManager = [[CLLocationManager alloc] init];
    }
    manager.locationManager.delegate = (id<CLLocationManagerDelegate> _Nullable)manager;
}

+ (NSData *)currentLocationData {
    BRTLocationInformation *info = [[BRTLocationInformation alloc] init];
    return [info currentLocationData];
}

#pragma mark - Private

static NSDate *lastTime = nil;
static CLAuthorizationStatus lastAuthorization = 0;

- (NSData *)currentLocationData {
    // reset current location
    self.currentLocation = nil;

    CLAuthorizationStatus authorization;
    NSDate *now = [NSDate date];
    if (lastAuthorization && lastTime && -[lastTime timeIntervalSinceNow] < 60) {
        authorization = lastAuthorization;
    }
    else {
        authorization = CLLocationManager.authorizationStatus;
        lastAuthorization = authorization;
        lastTime = now;
    }

    // check to see if location services is authorized
    switch (authorization) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            myprintf(" denied ");
            break;

        case kCLAuthorizationStatusAuthorizedWhenInUse:
            myprintf("i");
        case kCLAuthorizationStatusAuthorizedAlways:
            myprintf("a");
            // authorized, now check if the service is available
            if (CLLocationManager.locationServicesEnabled
                && locationGroup) {
                // use a weak reference so the metric doesn't stay around if the GPS_WAIT_TIME timeout occurs
                __block BOOL locationRequestCompleted = NO;
                NSLog(@"\nenter: %lx %lx %@", (long)&locationRequestCompleted, (long)locationRequestCompleted, [locationGroup debugDescription]);

                dispatch_group_enter(locationGroup);
                __weak BRTLocationInformation *weakSelf = self;
                myprintf("+");
                [manager requestLocationWithCompletion:^(CLLocation *location, NSError *error) {
                    @synchronized(weakSelf.currentLocation) {
                        if (error != nil) {
                            myprintf(" =f= ");
                            [BRTLog logError:BRTLog.metric format:@"❌ Failed to get current location for LocationData"];
                        }
                        else {
                            weakSelf.currentLocation = location;
                        }
                    }
                    myprintf("-");
                    // handle race condition if timeout
                    // while executing the completion block
                    @synchronized (locationGroup) {
                        NSLog(@"\nleave: %lx %lx %@", (long)&locationRequestCompleted, (long)locationRequestCompleted, [locationGroup debugDescription]);
                        if (!locationRequestCompleted) {
                            locationRequestCompleted = YES;
                            dispatch_group_leave(locationGroup);
                        }
                    }
                }];

                // do metric setup

                // wait for payload setup or timeout occurs
                // this keeps the current metric from being deallocated
                // before the completion is called or timeout occurs
                NSLog(@"\nwait0: %lx %lx %@", (long)&locationRequestCompleted, (long)locationRequestCompleted, [locationGroup debugDescription]);
                int64_t timeout = dispatch_group_wait(locationGroup, dispatch_time(DISPATCH_TIME_NOW, GPS_WAIT_TIME * NSEC_PER_SEC));
                // If the timeout passed before the location request completed
                // need to call dispatch_group_leave
                if (timeout) {
                    printf(" T%lld ",timeout);
                    NSLog(@"\nwait1: %lx %lx %@", (long)&locationRequestCompleted, (long)locationRequestCompleted, [locationGroup debugDescription]);
                    // handle race condition if completion block
                    // is executing when the timeout occurs
                    @synchronized (locationGroup) {
                        NSLog(@"\nwait2: %lx %lx %@", (long)&locationRequestCompleted, (long)locationRequestCompleted, [locationGroup debugDescription]);
                        if (!locationRequestCompleted) {
                            locationRequestCompleted = YES;
                            printf("_");
                            dispatch_group_leave(locationGroup);
                        }
                    }
                }
            }
            break;

        default:
            break;
    }
    return [self collectMetricPayload];
}

- (NSData *)collectMetricPayload {
    // build metric payload
    NSMutableData *outputData = [[NSMutableData alloc] init];
    if (self.currentLocation) {
    }
    else {
    }
    return outputData;

}

@end
