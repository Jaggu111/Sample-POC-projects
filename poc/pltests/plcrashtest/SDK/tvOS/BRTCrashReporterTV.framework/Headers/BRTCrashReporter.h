//
//  BRTCrashReporter.h
//  BRTCrashReporter
//
//  Created by Carl a Baltrunas on 5/10/19.
//  Copyright © 2019 AT&T CDO. All rights reserved.
//

//#import <UIKit/UIDevice.h>
//#import "BRTCrashReport.h"
#import <Foundation/Foundation.h>

//! Project version number for BRTCrashReporter.
FOUNDATION_EXPORT double BRTCrashReporterVersionNumber;

//! Project version string for BRTCrashReporter.
FOUNDATION_EXPORT const unsigned char BRTCrashReporterVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <BRTCrashReporter/PublicHeader.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRTCrashReporter : NSObject

+ (void)checkForCrashes;
+ (void)handleCrashReport;


@end

NS_ASSUME_NONNULL_END


