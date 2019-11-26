//
//  Util.m
//  DirectorySearch
//
//  Created by Carl a Baltrunas on 3/25/19.
//  Copyright © 2019 AT&T CDO. All rights reserved.
//

#import "Util.h"

@implementation Util

/**
 get URL of documents directory
 */
+ (NSURL *)documentsDirectoryURL {
    NSURL *documents = [[NSFileManager.defaultManager
#if TARGET_OS_TV
                         URLsForDirectory:NSCachesDirectory
#else  // for not tv os
                         URLsForDirectory:NSDocumentDirectory
#endif
                         inDomains:NSUserDomainMask]
                        firstObject];
    return documents;
}


/**
 get URL of library directory
 */
+ (NSURL *)libraryDirectoryURL {
    static NSURL *library = nil;
    if (!library) {
        library = [[NSFileManager.defaultManager
#if TARGET_OS_TV
                    URLsForDirectory:NSCachesDirectory
#else  // for not tv os
                    URLsForDirectory:NSLibraryDirectory
#endif
                    inDomains:NSUserDomainMask]
                   firstObject];
    }
    return library;
}


+ (NSURL *)URLFor:(NSSearchPathDirectory)directory
        inDomains:(NSSearchPathDomainMask)mask {
    NSArray *array = [NSFileManager.defaultManager
                      URLsForDirectory:directory inDomains:mask];
    NSLog(@"URLFor: %lu: %@", (unsigned long)directory, array);
    NSURL *url = array.firstObject;
    return url;
}

@end
