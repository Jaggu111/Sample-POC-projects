//  BRTDiagnostics.h
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
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BrightDiagnostics.h"

@class BRTLocationManager;
@class BRTPackageManager;

@interface BRTDiagnostics : NSObject
@property (nonatomic, strong) BRTLocationManager * _Nonnull locationManager;
@property (nonatomic, strong) BRTPackageManager * _Nonnull packageManager;
@property (atomic) UIApplicationState applicationState;
@property (atomic) BOOL realTimeUploads;
@property (atomic) BOOL sdkEnabled;
@property (atomic, copy, nullable) BRTDataCollectionEventHandler collectionHandler;
@property (atomic, strong, nullable) NSString *collectionRestrictionISOCountry;
@property (atomic, readonly) NSTimeInterval timedCollectionInterval;
@property (atomic) CLLocationAccuracy desiredLocationAccuracy;

@property (atomic, strong, nullable) NSString *session;
@property (atomic, strong, nullable) NSString *accountID;
@property (atomic, strong, nullable) NSString *userID;
@property (atomic, strong, nullable) NSString *streamID;
@property (atomic, strong, nullable) NSString *contentNetwork;
@property (atomic, assign) float bitRate;

+ (instancetype _Nonnull )shared;

- (void)collectWithReason:(BRTDataCollectionReason)reason;

#if TARGET_OS_IOS
- (BOOL)startSignificantLocationChangeCollection;
- (void)stopSignificantLocationChangeCollection;
#endif

- (void)startTimedCollectionWithTimeInterval:(NSTimeInterval)interval;
- (void)stopTimedCollection;
- (uint64_t)GPSTime;

+ (void)setDefaultApplicationPropertiesWithSession:(NSString *_Nullable)session
                                           account:(NSString *_Nullable)account
                                              user:(NSString *_Nullable)user;

+ (void)clearDefaultApplicationProperties;

+ (void)setDefaultStreamPropertiesWith:(NSString *_Nullable)stream
                               network:(NSString *_Nullable)contentNetwork
                                  rate:(float)bitRate;

+ (void)clearDefaultStreamProperties;


@end
