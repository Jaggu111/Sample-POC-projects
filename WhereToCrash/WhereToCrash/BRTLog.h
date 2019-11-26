//  BRTLog.h
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
#import <os/log.h>

@interface BRTLog : NSObject

/// PackageGenerator log
@property (class, readonly) os_log_t packageGenerator;
/// PackageUploader log
@property (class, readonly) os_log_t packageUploader;
/// LocationManager log
@property (class, readonly) os_log_t locationManager;
/// SignifcantLocationChange log
@property (class, readonly) os_log_t significantLocationChange;
/// Restrictions log
@property (class, readonly) os_log_t restrictions;
/// Metric log
@property (class, readonly) os_log_t metric;
/// Device storage log
@property (class, readonly) os_log_t storageManager;

/**
 Log message
 
 If not DEBUG, only errors/faults are logged.

 @param log Log to write to
 @param type Log level
 @param format Message
 */
+ (void)logWithType:(os_log_t)log type:(os_log_type_t)type format:(NSString *)format, ...;

/**
 Log debug
 
 Only logged for DEBUG builds

 @param log Log to write to
 @param format Message
 */
+ (void)logDebug:(os_log_t)log format: (NSString *)format, ...;

/**
 Log error

 @param log Log to write to
 @param format Message
 */
+ (void)logError:(os_log_t)log format: (NSString *)format, ...;

@end
