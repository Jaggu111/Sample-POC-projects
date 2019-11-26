//
//  LC18.m
//  iqiSDK
//
// **********************************************************************************
// *                                                                                *
// *    Copyright (c) 2017 AT&T Intellectual Property. ALL RIGHTS RESERVED          *
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

#import "LC18.h"


@implementation LC18

static const int IQ_GPS_WAIT_TIME = 60;
static int maxWaitTime = 0;
static BOOL continuousPolling = YES;

static CLLocationManager *locationManager = nil;
static CLLocation *currentLocation = nil;
static CLLocation *lastKnownLocation = nil;
static NSMutableArray *allMyVisits = nil;
static VisitCompletionBlock myFinishBlock = nil;

/*!
 *  @method metricId
 *  @abstract   set the proper metric ID
 *
 */
- (iq_metric_id_t)metricId {
    return IQ_MAKE_ID('L','C','1','8');
}

- (void)setGPSPolling:(BOOL)state {
    continuousPolling = state;
    if (continuousPolling) {
        // enable polling
        [self setupLocationPolling];
    }
    else {
        // disable polling
        [self stopLocationPolling];
    }
}

- (CLLocation *)myLocation {
    // add specific metric data to payload

    // do metric setup
    self.needsCompletion = YES;
    currentLocation = nil;

    // Apple does not allow the creation or use of a
    // location manager if it is not performed on the
    // main thread, perform this setup on the main thread
    [self setupLocationPolling];

    if (locationManager.location) {
        // stopping locationManager from fetching again
        [locationManager stopUpdatingLocation];
        if (continuousPolling) {
            [locationManager startUpdatingLocation];
        }
        return locationManager.location;
    }
    else {
        // wait for payload setup
        maxWaitTime = IQ_GPS_WAIT_TIME;
        while (self.needsCompletion && (maxWaitTime > 0)) {
            // sleep repetedly until location is available
            [NSThread sleepForTimeInterval:1.0f];
            if (--maxWaitTime < 1) {
                [self stopLocationPolling];
                if (continuousPolling) {
                    [locationManager startUpdatingLocation];
                }
                // clear the location
                currentLocation = nil;
            }
        }
    }

    // build metric payload
    if (currentLocation) {
        lastKnownLocation = currentLocation;
        return currentLocation;
    }
    else {
        return nil;
    }
 
}


- (void)enableVisitsWithCompletion:(VisitCompletionBlock)finishBlock {
    if (!allMyVisits) {
        @synchronized (allMyVisits) {
            allMyVisits = [[NSMutableArray alloc] init];
        }
    }

    myFinishBlock = finishBlock;
    if (myFinishBlock) {
        [self setupVisitPolling];
    }

    [[NSNotificationCenter defaultCenter]
     removeObserver:self];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(justVisiting:)
     name:@"FakeVisit"
     object:nil];

}

- (void)justVisiting:(NSNotification *)notification {
    CLVisit *visit = notification.userInfo[@"Visit"];
    if (visit) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JustVisiting" object:nil userInfo:@{@"Visit": visit}];
    }
}


- (void)disableVisits {
    [self stopVisitPolling];
}

- (NSMutableArray *)myVisits {
    NSMutableArray *myVisits = allMyVisits;
    @synchronized (allMyVisits) {
        // make sure we don't update this elsewhere during switch
        // anything using the old pointer will just give us that too
        // new entries will go in the next set
        allMyVisits = [[NSMutableArray alloc] init];
    }
    return myVisits;
}



- (void)setupLocationPolling {
    if (!locationManager) {
        // first time through -- otherwise use same manager
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    [locationManager stopUpdatingLocation];
//    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
}

- (void)stopLocationPolling {
    if (locationManager) {
        [locationManager stopUpdatingLocation];
        if (continuousPolling) {
            // restart locationManager polling
            [locationManager startUpdatingLocation];
        }
        // allow wait loop to fall through if necessary
        self.needsCompletion = NO;
        // locationManager = nil;
    }
}


- (void)setupVisitPolling {
    if (!locationManager) {
        // first time through -- otherwise use same manager
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
//    [locationManager stopMonitoringVisits];
//    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [locationManager startMonitoringVisits];
}

- (void)stopVisitPolling {
    if (locationManager) {
        [locationManager stopMonitoringVisits];
    }
}


#pragma mark - delegate methods for CLLocation

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {

    if (locations.count > 0) {
        [locationManager stopUpdatingLocation];
        if (continuousPolling) {
            // restart locationManager from fetching again
            [locationManager startUpdatingLocation];
        }
        // grab the top location
        currentLocation = locations[0];
        // ** DO NOT ** clear maxWaitTime as that will clear the location
        // notify the sleeping collector that there is a location to read
        self.needsCompletion = NO;
        // clear the locationManager instance
        // locationManager = nil;
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"%s: failed to fetch current location: %@", __FUNCTION__, error);
    if (locationManager) {
        [locationManager stopUpdatingLocation];
        if (continuousPolling) {
            [locationManager startUpdatingLocation];
        }
    }
    locationManager = nil;
}

- (void)locationManager:(CLLocationManager *)manager
               didVisit:(CLVisit *)visit {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JustVisiting" object:nil userInfo:@{@"Visit": visit}];

    if (allMyVisits) {
        [allMyVisits addObject:visit];
    }
    if (nil != myFinishBlock) {
        myFinishBlock(visit);
    }
}


@end
