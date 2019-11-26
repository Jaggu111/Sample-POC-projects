//
//  BRTCrashReporter.m
//  SampleBRTCrashTest
//
//  Created by Carl a Baltrunas on 5/8/19.
//  Copyright © 2019 AT&T CDO. All rights reserved.
//

#import "BRTCrashReporter.h"
//#import <CrashReporter/CrashReporter.h>
#import <>
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
    NSMutableString *crashText = [NSMutableString string];
    NSError *error;

    // Try loading the crash report
    NSData *crashData = [crashReporter loadPendingCrashReportDataAndReturnError: &error];
    if (crashData) {
        // We could send the report from here, but we'll just print out
        // some debugging info instead
        //NSLog(@"Crashed Data Length: %lu\rData::\r%@", (unsigned long)crashData.length, crashData);
        [crashText appendFormat:@"%-20s %lu", "Crashed Data Length:", (unsigned long)crashData.length];

        PLCrashReport *report = [[PLCrashReport alloc] initWithData: crashData error: &error];
        if (report) {
            [crashText appendFormat:@"\n\n%-20s %@\n", "Crashed on:", report.systemInfo.timestamp];
            [crashText appendFormat:@"%-20s %@ (code %@, address=0x%llx)\n",
             "Crashed with signal:",
                    report.signalInfo.name,
                    report.signalInfo.code,
                    report.signalInfo.address];
            [crashText appendFormat:@"%-20s %@\n%-20s %llu\n%-20s %llu\n%-20s %lu:%lu\n",
             "Model:",
                    report.machineInfo.modelName,
             "Type:",
                    report.machineInfo.processorInfo.type,
             "SubType:",
                    report.machineInfo.processorInfo.subtype,
             "Processors:",
                    report.machineInfo.processorCount,
                    report.machineInfo.logicalProcessorCount];
            NSString *OSName = @"iOS";
            if (report.systemInfo.operatingSystem >= 0
                && report.systemInfo.operatingSystem <= 3) {
                OSName = @[ @"macOS", @"iPhoneOS", @"simulatorOS", @"unknownOS"][report.systemInfo.operatingSystem];
            }
            [crashText appendFormat:@"%-20s %@ (%@ %@) arch %d\n",
             "System:",
                    OSName,
                    report.systemInfo.operatingSystemVersion,
                    report.systemInfo.operatingSystemBuild,
                    report.systemInfo.architecture];
            [crashText appendFormat:@"%-20s %@ [%lu]\n%-20s %@\n",
             "Process:",
                    report.processInfo.processName,
                    report.processInfo.processID,
             "Path:",
                    report.processInfo.processPath];
            [crashText appendFormat:@"%-20s %@ [%lu]\n",
             "Parent Process:",
                    report.processInfo.parentProcessName,
                    report.processInfo.parentProcessID];
            [crashText appendFormat:@"%-20s %@ version: %@\n",
             "Application:",
                    report.applicationInfo.applicationIdentifier,
                    report.applicationInfo.applicationVersion];
            [crashText appendFormat:@"%-20s %@ \n",
             "TheExceptionInfo Name:",
             report.exceptionInfo.exceptionName];
            [crashText appendFormat:@"%-20s %@ \n",
             "TheExceptionInfo Reason:",
             report.exceptionInfo.exceptionReason];
            [crashText appendFormat:@"%-20s %@ \n",
             "TheExceptionInfo stackFrames:",
             report.exceptionInfo.stackFrames];
            int16_t stackCount = -1;
            NSMutableString *threadStack = [NSMutableString string];
            [threadStack appendString:@"\n"];
            for (PLCrashReportStackFrameInfo *frame in report.exceptionInfo.stackFrames) {
                stackCount++;
                PLCrashReportBinaryImageInfo *image = [report imageForAddress:(frame.instructionPointer & 0xfffffffff)];
                if (image) {
                    BOOL isSystemImage = [BRTImageInfo isSystem:image.imageName];
                    uint64_t baseAddress = image.imageBaseAddress;
                    [threadStack appendFormat:@"\n%6d %s %36s %s 0x%llx + %lld",
                     stackCount,
                      " " ,
                     [[image.imageName lastPathComponent] UTF8String],
                      "||",
                     baseAddress,
                     ((frame.instructionPointer & 0xfffffffff) - baseAddress)];
                    //     [threadStack appendFormat:@"(%@ 0x%llx - %llx)",frame.symbolInfo.symbolName,frame.symbolInfo.startAddress,frame.symbolInfo.endAddress];
                    [threadStack appendFormat:@"  (%@ 0x%llx - %llu)",image.imageName.lastPathComponent, baseAddress,image.imageSize];
                   
                }
                else {
                    [threadStack appendFormat:@"\n%6d   %36s || 0x%llx",
                     stackCount,
                     "--unknown--",
                     frame.instructionPointer];
                }
            }
            
            [crashText appendString:threadStack];
            
            [crashText appendFormat:@"%-20s %llu \n",
             "ExceptionInfo Type:",
             report.machExceptionInfo.type];
            
            [crashText appendFormat:@"%-20s %@ \n",
             "ExceptionInfo Codes:",
             report.machExceptionInfo.codes];

            // do threads
            if (report.threads && report.threads.count > 0) {
                [crashText appendFormat:@"%-20s %lu\n\n", "Thread count:", (unsigned long)report.threads.count];
                for (PLCrashReportThreadInfo *thread in report.threads) {
                    // start each thread stack as no non-system images
                    BOOL seenNonSystemImage = NO;
                    NSMutableString *threadStack = [NSMutableString string];
                    [threadStack appendString:@"\n"];
                    [threadStack appendFormat:@"Thread %ld%s",
                          (long)thread.threadNumber,
                          thread.crashed ? " crashed" : ""];
                    if (thread.stackFrames && thread.stackFrames.count > 0) {
                        [threadStack appendFormat:@"\nStack count: %lu",
                                        (unsigned long)thread.stackFrames.count];

                        int16_t stackCount = -1;
                        for (PLCrashReportStackFrameInfo *frame in thread.stackFrames) {
                            stackCount++;
                            PLCrashReportBinaryImageInfo *image = [report imageForAddress:(frame.instructionPointer & 0xfffffffff)];
                            if (image) {
                                BOOL isSystemImage = [BRTImageInfo isSystem:image.imageName];
                                uint64_t baseAddress = image.imageBaseAddress;
                                [threadStack appendFormat:@"\n%6d %s %36s %s 0x%llx + %lld",
                                                stackCount,
                                                (isSystemImage || seenNonSystemImage) ? " " : "*",
                                                [[image.imageName lastPathComponent] UTF8String],
                                                (isSystemImage || seenNonSystemImage) ? "||" : "**",
                                                baseAddress,
                                                ((frame.instructionPointer & 0xfffffffff) - baseAddress)];
                           //     [threadStack appendFormat:@"(%@ 0x%llx - %llx)",frame.symbolInfo.symbolName,frame.symbolInfo.startAddress,frame.symbolInfo.endAddress];
                                [threadStack appendFormat:@"  (%@ 0x%llx - %llu)",image.imageName.lastPathComponent, baseAddress,image.imageSize];
                                // update if seen non-system image yet in this thread
                                if (!isSystemImage && !seenNonSystemImage) {
                                    seenNonSystemImage = YES;
                                }
                            }
                            else {
                                [threadStack appendFormat:@"\n%6d   %36s || 0x%llx",
                                                stackCount,
                                                "--unknown--",
                                                frame.instructionPointer];
                            }
                        }
                        [threadStack appendString:@"\n"];
                        if (thread.crashed && thread.registers && thread.registers.count > 0) {
                            [threadStack appendString:@"\nRegisters:"];
                            for (PLCrashReportRegisterInfo *regInfo in thread.registers) {
                                [threadStack appendFormat:@"\n%6s: 0x%016llx",
                                 [regInfo.registerName UTF8String],
                                 regInfo.registerValue];
                            }

                        }
                        [threadStack appendString:@"\n"];
                        [crashText appendString:threadStack];
                    }
                }
            }
            else {
                [crashText appendString:@"No threads detected"];
            }

            // do images
            if (report.images && report.images.count > 0) {
                [crashText appendFormat:@"\n%-20s %lu\n", "Image count:", (unsigned long)report.images.count];
                for (PLCrashReportBinaryImageInfo *image in report.images) {
//                    [crashText appendFormat:@"\n%@ 0x%9llx x%9llx %s (%@)",
//                          image.hasImageUUID ? "U" : " ",
//                          image.hasImageUUID ? image.imageUUID : @"",
                    [crashText appendFormat:@"\n0x%9llx - x%9llx %@",
                          image.imageBaseAddress,
                          image.imageBaseAddress + image.imageSize - 1,
                          image.imageName
                     ];
                }
            }
            else {
                [crashText appendFormat:@"No images detected" ];
            }

        }
        else {
            [crashText appendString:@"Could not parse crash report"];
        }
        NSLog(@"%@\n", crashText);
        
//        NSData *reportData = [[BrightPLCrashReportTextFormatter alloc] formatReport:report error:&error];
//        NSLog(@"%@\n", reportData);
        
        NSString* reportText = [PLCrashReportTextFormatter stringValueForCrashReport: report withTextFormat: PLCrashReportTextFormatiOS];
        NSLog(@"%@\n", reportText);
        
    }
    else {
        NSLog(@"Could not load crash report: %@", error);
    }

    // Purge the report
    [crashReporter purgePendingCrashReport];
    return;
}


@end
