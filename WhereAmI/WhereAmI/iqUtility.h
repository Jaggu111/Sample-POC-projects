//
//  iqUtility.h
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

#import <Foundation/Foundation.h>

@interface iqUtility : NSObject

// Convenience methods
+ (id)bundleObject:(NSString *)bundleField;

+ (NSURL *)documentsURL;
+ (NSURL *)libraryURL;
+ (NSURL *)iqPrivateURL;
+ (NSURL *)iqPackageURL;
+ (NSURL *)iqMetricsURL;

+ (NSString *)nextPackageName;
+ (void)removePackageName:(NSString *)fileName;
+ (BOOL)isActive;

// insure package directory exists
+ (void)setupPackageDirectory;

@end
