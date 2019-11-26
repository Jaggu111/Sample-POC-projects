//
//  BRTImageInfo.m
//  BRTCrashReporter
//
//  Created by Carl a Baltrunas on 5/10/19.
//  Copyright © 2019 AT&T CDO. All rights reserved.
//

#import "BRTImageInfo.h"

@implementation BRTImageInfo


+ (BOOL)isSystem:(NSString *)imagePath {
    if ([imagePath containsString:@"/Resources/RuntimeRoot/"]) {
        return YES;
    }
    if ([imagePath containsString:@"/System/Library/"]) {
        NSRange range = [imagePath rangeOfString:@"/System/Library/"];
        if (range.location == 0) {
            return YES;
        }
    }
    else {
        if ([imagePath containsString:@"/usr/lib"]) {
            NSRange range = [imagePath rangeOfString:@"/usr/lib"];
            if (range.location == 0) {
                return YES;
            }
        }
    }
    return NO;
}

+ (BOOL)isFramework:(NSString *)imagePath {
    if ([imagePath containsString:@"Frameworks/"]
        || [imagePath containsString:@".framework/"]
        ) {
        return YES;
    }
    return NO;
}

+ (BOOL)isPrivate:(NSString *)imagePath {
    if ([imagePath containsString:@"/Private"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isLibrary:(NSString *)imagePath {
    if ([imagePath containsString:@"/Library/"]
        || [imagePath containsString:@"/lib/"]
        ) {
        return YES;
    }
    return NO;
}

+ (BOOL)isSimulator:(NSString *)imagePath {
    if ([imagePath containsString:@"/Resources/RuntimeRoot/"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isApp:(NSString *)imagePath {
    if ([imagePath containsString:@".app/"]) {
        NSRange range = [imagePath rangeOfString:@".app/"];
        NSUInteger index = range.location + range.length;
        NSString *appname = [imagePath substringFromIndex:index];
        if (range.location >= appname.length) {
            index = range.location - appname.length;
            range.location = index;
            range.length = appname.length;
            NSString *myAppname = [imagePath substringWithRange:range];
            if ([appname isEqualToString:myAppname]) {
                return YES;
            }
        }
    }
    return NO;
}

+ (BOOL)isInApp:(NSString *)imagePath {
    if ([imagePath containsString:@".app/"]) {
        return YES;
    }
    return NO;
}


+ (NSString *)middleName:(NSString *)name {
    NSRange range;
    NSUInteger index;
    NSString *myName;

    // Application or something inside the application
    range = [name rangeOfString:@"ontainers/Bundle/Application/"];
    if (range.location != NSNotFound) {
        index = range.location + range.length;
        return [name substringFromIndex:index];
    }

    // Libraries inside of Xcode or some simulator platform
    if ([name containsString:@"/Resources/RuntimeRoot/"]) {
        range = [name rangeOfString:@"/Resources/RuntimeRoot"];
        index = range.location + range.length;
        return [name substringFromIndex:index];
    }
    return myName;
}


@end
