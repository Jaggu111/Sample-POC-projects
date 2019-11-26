//
//  BRTImages.h
//  plcrashtest
//
//  Created by Carl a Baltrunas on 5/6/19.
//  Copyright © 2019 AT&T CDO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRTCrashReporter.h"

NS_ASSUME_NONNULL_BEGIN

@interface BRTImages : NSObject

+ (BOOL)setupImagesUsing:(NSArray *)binaryImages;
+ (PLCrashReportBinaryImageInfo *)imageForAddress:(uint64_t)address;


@end

NS_ASSUME_NONNULL_END
