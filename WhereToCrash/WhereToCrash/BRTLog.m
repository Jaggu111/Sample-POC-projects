//  BRTLog.m
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

#import "BRTLog.h"

@implementation BRTLog

static os_log_t _packageGenerator;
static os_log_t _packageUploader;
static os_log_t _locationManager;
static os_log_t _significantLocationChange;
static os_log_t _restrictions;
static os_log_t _metric;
static os_log_t _storageManager;

#pragma mark Public Log Definitions

+ (NSString *)bundleIdentifier {
    static NSString *bundleIdentifier = nil;
    if (!bundleIdentifier) {
        bundleIdentifier = [NSBundle bundleForClass:BRTLog.class].bundleIdentifier;
    }
    return bundleIdentifier;
}

+ (os_log_t)packageGenerator {
    @synchronized(_packageGenerator) {
        if (!_packageGenerator) {
            _packageGenerator = os_log_create([[BRTLog bundleIdentifier] cStringUsingEncoding:NSUTF8StringEncoding], "📦 Package Generator");
        }
        return _packageGenerator;
    }
}

+ (os_log_t)packageUploader {
    @synchronized(_packageUploader) {
        if (!_packageUploader) {
            _packageUploader = os_log_create([[BRTLog bundleIdentifier] cStringUsingEncoding:NSUTF8StringEncoding], "📦⬆️ Package Uploader");
        }
        return _packageUploader;
    }
}

+ (os_log_t)locationManager {
    @synchronized(_locationManager) {
        if (!_locationManager) {
            _locationManager = os_log_create([[BRTLog bundleIdentifier] cStringUsingEncoding:NSUTF8StringEncoding], "🌐 Location Manager");
        }
        return _locationManager;
    }
}

+ (os_log_t)significantLocationChange {
    @synchronized(_significantLocationChange) {
        if (!_significantLocationChange) {
            _significantLocationChange = os_log_create([[BRTLog bundleIdentifier] cStringUsingEncoding:NSUTF8StringEncoding], "🌐📍 Significant Location Change Trigger");
        }
        return _significantLocationChange;
    }
}

+ (os_log_t)restrictions {
    @synchronized(_restrictions) {
        if (!_restrictions) {
            _restrictions = os_log_create([[BRTLog bundleIdentifier] cStringUsingEncoding:NSUTF8StringEncoding], "⛔️ Restrictions");
        }
        return _restrictions;
    }
}

+ (os_log_t)metric {
    @synchronized(_metric) {
        if (!_metric) {
            _metric = os_log_create([[BRTLog bundleIdentifier] cStringUsingEncoding:NSUTF8StringEncoding], "📊 Metric");
        }
        return _metric;
    }
}

+ (os_log_t)storageManager {
    @synchronized(_storageManager) {
        if (!_storageManager) {
            _storageManager = os_log_create([[BRTLog bundleIdentifier] cStringUsingEncoding:NSUTF8StringEncoding], "📂 Storage Manager");
        }
        return _storageManager;
    }
}

#pragma mark Public Logging Methods

+ (void)logWithType:(os_log_t)log type:(os_log_type_t)type format:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    [BRTLog logWithType:log type:type format:format args:args];
    va_end(args);
}



+ (void)logDebug:(os_log_t)log format: (NSString *)format, ... {
#ifndef DEBUG
    return;
#else
    va_list args;
    va_start(args, format);
    [BRTLog logWithType:log type:OS_LOG_TYPE_DEBUG format:format args:args];
    va_end(args);
#endif
}

+ (void)logError:(os_log_t)log format: (NSString *)format, ... {
    va_list args;
    va_start(args, format);
    [BRTLog logWithType:log type:OS_LOG_TYPE_ERROR format:format args:args];
    va_end(args);
}

#pragma mark Private

// Need to have an internal method that takes va_args in order to forward args
+ (void)logWithType:(os_log_t)log type:(os_log_type_t)type format:(NSString *)format args:(va_list)args {
    switch (type) {
            // if not DEBUG, only errors/faults are logged
        case OS_LOG_TYPE_INFO:
        case OS_LOG_TYPE_DEBUG:
        case OS_LOG_TYPE_DEFAULT:
#ifndef DEBUG
            return;
#endif
        default:
            break;
    }
    NSString *formatString = [[NSString alloc] initWithFormat:format arguments:args];
    os_log_with_type(log, type, "%{public}@", formatString);
}

@end
