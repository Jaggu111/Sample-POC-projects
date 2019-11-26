//
//  BRTLocationManager.h
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

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 Provides results of the location fetch

 @param location The location
 @param error Any error that occured
 */
typedef void (^BRTLocationRequestCompletion)(CLLocation *location, NSError *error);

@interface BRTLocationManager : NSObject

/// The last valid location
@property (atomic, strong, readonly) CLLocation *location;
/// Desired accuracy
@property (nonatomic) CLLocationAccuracy desiredAccuracy;

// no shared BDTDiagnosics
@property (nonatomic, strong) CLLocationManager *locationManager;
/**
 Request a new location
 
 If a previous valid location was recorded within the last 60s, then that cached
 location will be returned. Otherwise a new location will be fetched using the
 `desiredAccuracy` value.
 
 If a location fetch is already in progress, this request will wait for that to return.

 @param completion The results of the location request
 */
- (void)requestLocationWithCompletion:(BRTLocationRequestCompletion)completion;

@end
