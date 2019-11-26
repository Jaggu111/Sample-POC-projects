//
//  BRTCrashReporter.h
//  SampleBRTCrashTest
//
//  Created by Carl a Baltrunas on 5/8/19.
//  Copyright © 2019 AT&T CDO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRTCrashReporter : NSObject

+ (void)checkForCrashes;
+ (void)handleCrashReport;


@end

NS_ASSUME_NONNULL_END
