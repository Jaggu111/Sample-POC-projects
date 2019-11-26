//
//  BRTCrashReporter.m
//  BRTCrashReporter
//
//  Created by Carl a Baltrunas on 5/8/19.
//  Copyright © 2019 AT&T CDO. All rights reserved.
//

#import "BRTCrashReporter.h"
#import <BrightCrashReporter/CrashReporter.h>
#import <UIKit/UIDevice.h>
#import "BRTImageInfo.h"


@implementation BRTCrashReporter

//
// main external entry point
//
+ (void)checkForCrashes {
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSError *error;

    // Check if we previously crashed
    if ([crashReporter hasPendingCrashReport]) {
        // NSLog(@"Warning: crashReporter hasPendingCrashReport");
        [self handleCrashReport];
    }
    else {
        // NSLog(@"Warning: crashReporter no crash reports");
    }

    // Enable the Crash Reporter
    if (![crashReporter enableCrashReporterAndReturnError: &error]) {
        //NSLog(@"Warning: Could not enable crash reporter: %@", error);
    }

}

//
// Called to handle a pending crash report.
//
+ (void)handleCrashReport {
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSError *error;

    // Try loading the crash report
    NSData *crashData = [crashReporter loadPendingCrashReportDataAndReturnError: &error];
    if (crashData) {
        // We could send the report from here, but we'll just print out
        // some debugging info instead
        //NSLog(@"Crashed Data Length: %lu\rData::\r%@", (unsigned long)crashData.length, crashData);
        NSLog(@"Crashed Data Length: %lu", (unsigned long)crashData.length);

        PLCrashReport *report = [[PLCrashReport alloc] initWithData: crashData error: &error];
        if (report) {
            NSLog(@"Crashed on %@", report.systemInfo.timestamp);
            NSLog(@"Crashed with signal %@ (code %@, address=0x%" PRIx64 ")", report.signalInfo.name,
                  report.signalInfo.code, report.signalInfo.address);
            NSLog(@"System: %d (%@ %@) arch %d",
                  report.systemInfo.operatingSystem,
                  report.systemInfo.operatingSystemVersion,
                  report.systemInfo.operatingSystemBuild,
                  report.systemInfo.architecture);
            NSLog(@"Model: %@ type: %llu subType: %llu processor: %lu:%lu",
                  report.machineInfo.modelName,
                  report.machineInfo.processorInfo.type,
                  report.machineInfo.processorInfo.subtype,
                  (unsigned long)report.machineInfo.processorCount,
                  (unsigned long)report.machineInfo.logicalProcessorCount);
            NSLog(@"Application: %@ version: %@",
                  report.applicationInfo.applicationIdentifier,
                  report.applicationInfo.applicationVersion);
            if (report.images && report.images.count > 0) {
                NSLog(@"Image count: %lu", (unsigned long)report.images.count);
//                [BRTImages setupImagesUsing:report.images];
//                for (PLCrashReportBinaryImageInfo *image in report.images) {
//                    NSLog(@"Image Name %s (%@)\n%@ 0x%llx x%llx",
//                          image.hasImageUUID ? "U" : " ",
//                          image.hasImageUUID ? image.imageUUID : @"",
//                          image.imageName,
//                          image.imageBaseAddress,
//                          image.imageSize);
//                }
            }
            else {
                NSLog(@"No images detected");
            }
            if (report.threads && report.threads.count > 0) {
                NSLog(@"Thread count: %lu", (unsigned long)report.threads.count);
                for (PLCrashReportThreadInfo *thread in report.threads) {
                    NSMutableString *threadStack = [NSMutableString string];
                    [threadStack appendString:@"\n\n"];
                    [threadStack appendFormat:@"Thread %ld%s",
                          (long)thread.threadNumber,
                          thread.crashed ? " crashed" : ""];
                    if (thread.stackFrames && thread.stackFrames.count > 0) {
                        [threadStack appendFormat:@"\nStack count: %lu",
                                        (unsigned long)thread.stackFrames.count];

                        int16_t stackCount = -1;
                        for (PLCrashReportStackFrameInfo *frame in thread.stackFrames) {
                            stackCount++;
                            PLCrashReportBinaryImageInfo *image = [report imageForAddress:frame.instructionPointer];
                            if (image) {
                                uint64_t baseAddress = image.imageBaseAddress;
                                [threadStack appendFormat:@"\n%6d %36s || 0x%llx + %lld",
                                                stackCount,
                                                [[image.imageName lastPathComponent] UTF8String],
                                                baseAddress,
                                                (frame.instructionPointer - baseAddress)];
                            }
                            else {
                                [threadStack appendFormat:@"\n%6d %36s || 0x%llx",
                                                stackCount,
                                                "--unknown--",
                                                frame.instructionPointer];
                            }
                        }
                        [threadStack appendString:@"\n \n \n"];
                        NSLog(@"%@", threadStack);
                    }
                }
            }
            else {
                NSLog(@"No threads detected");
            }
        }
        else {
            NSLog(@"Could not parse crash report");
        }
    }
    else {
        NSLog(@"Could not load crash report: %@", error);
    }

    // Purge the report
    [crashReporter purgePendingCrashReport];
    return;
}


@end
