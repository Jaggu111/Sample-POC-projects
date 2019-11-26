//
//  BRTImage.h
//  plcrashtest
//
//  Created by Carl a Baltrunas on 5/8/19.
//  Copyright © 2019 AT&T CDO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRTCrashReporter.h"

NS_ASSUME_NONNULL_BEGIN

@interface PLCrashReportBinaryImageInfo (BRTImage)

@property (nonatomic, strong) NSString *imageShortName;
@property (nonatomic, strong) NSString *imageMiddleName;
@property (nonatomic, assign) BOOL isApp;
@property (nonatomic, assign) BOOL isInApp;
@property (nonatomic, assign) BOOL isSystem;
@property (nonatomic, assign) BOOL isFramework;
@property (nonatomic, assign) BOOL isLibrary;
@property (nonatomic, assign) BOOL isPrivate;
@property (nonatomic, assign) BOOL isDevice;
@property (nonatomic, assign) BOOL isSimulator;


@end


NS_ASSUME_NONNULL_END
