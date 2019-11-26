//
//  BRTImageInfo.h
//  BRTCrashReporter
//
//  Created by Carl a Baltrunas on 5/10/19.
//  Copyright © 2019 AT&T CDO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRTImageInfo : NSObject

+ (BOOL)isSystem:(NSString *)imagePath;
+ (BOOL)isFramework:(NSString *)imagePath;
+ (BOOL)isPrivate:(NSString *)imagePath;
+ (BOOL)isLibrary:(NSString *)imagePath;
+ (BOOL)isSimulator:(NSString *)imagePath;
+ (BOOL)isApp:(NSString *)imagePath;
+ (BOOL)isInApp:(NSString *)imagePath;

+ (NSString *)middleName:(NSString *)name;


@end

NS_ASSUME_NONNULL_END
