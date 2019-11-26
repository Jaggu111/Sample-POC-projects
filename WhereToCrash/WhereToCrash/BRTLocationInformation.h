//  BRTLocationInformation.h
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

@interface BRTLocationInformation : NSObject

@property (strong, atomic, class) CLLocationManager *locationManager;

/**
 Returns current location information data formatted for metric submission.

 @warning This method will block waiting until a location is available, or
 until a 60s timeout has occured.

 @return Location data formatted for metric submission.
 */
+ (NSData *)currentLocationData;


@end
