//
//  ScanDirectory.m
//  DirectorySearch
//
//  Created by Carl a Baltrunas on 3/28/19.
//  Copyright © 2019 AT&T CDO. All rights reserved.
//

#import "ScanDirectory.h"
#import "Util.h"

//
//typedef NS_OPTIONS(NSUInteger, NSSearchPathDomainMask) {
//    NSUserDomainMask = 1,       // user's home directory --- place to install user's personal items (~)
//    NSLocalDomainMask = 2,      // local to the current machine --- place to install items available to everyone on this machine (/Library)
//    NSNetworkDomainMask = 4,    // publically available location in the local area network --- place to install items available on the network (/Network)
//    NSSystemDomainMask = 8,     // provided by Apple, unmodifiable (/System)
//    NSAllDomainsMask = 0x0ffff  // all domains: all of the above and future items
//};

@interface ScanDirectory (internal)

@end



@implementation ScanDirectory

static NSFileManager *fileManager = nil;

+ (NSArray *)topLevelDirectories {
    return @[@(NSApplicationDirectory)
             , @(NSDemoApplicationDirectory)
             , @(NSDeveloperApplicationDirectory)
             , @(NSAdminApplicationDirectory)
             , @(NSLibraryDirectory)
             , @(NSUserDirectory)
             , @(NSDocumentationDirectory)
             , @(NSDocumentDirectory)
             , @(NSCoreServiceDirectory)
             , @(NSAutosavedInformationDirectory)
             , @(NSDesktopDirectory)
             , @(NSCachesDirectory)
             , @(NSApplicationSupportDirectory)
             , @(NSDownloadsDirectory)
             , @(NSInputMethodsDirectory)
             , @(NSMoviesDirectory)
             , @(NSMusicDirectory)
             , @(NSPicturesDirectory)
             , @(NSPrinterDescriptionDirectory)
             , @(NSSharedPublicDirectory)
             , @(NSPreferencePanesDirectory)
             , @23
             , @(NSItemReplacementDirectory)
             , @(NSAllApplicationsDirectory)
             , @(NSAllLibrariesDirectory)
             , @(NSTrashDirectory)
             ];
}

+ (void)showTopLevelDirectories {
    NSLog(@"-- Top Level --");
    NSURL *URL;
    for (NSNumber *directory in ScanDirectory.topLevelDirectories) {
        URL = [Util URLFor:[directory longValue] inDomains:NSUserDomainMask];
        if (URL) {
            [ScanDirectory printFilesAtURL:URL];
        }

    }
    printf("\n\n");
    URL = [NSURL fileURLWithPath:@"/var"];
    [ScanDirectory printFilesAtURL:URL];
    URL = [NSURL fileURLWithPath:@"/var/mobile"];
    [ScanDirectory printFilesAtURL:URL];
    URL = [NSURL fileURLWithPath:@"/var/mobile/Containers/Data"];
    [ScanDirectory printFilesAtURL:URL];
    URL = [NSURL fileURLWithPath:@"/var/mobile/Containers/Data/Application"];
    [ScanDirectory printFilesAtURL:URL];
    URL = [NSURL fileURLWithPath:@"/var/mobile/Containers/Data/Application/6AA84D28-6E2F-4772-8BAD-68CDACD693C2"];
    [ScanDirectory printFilesAtURL:URL];
    URL = [NSURL fileURLWithPath:@"/var/mobile/Containers/Data/Application/6AA84D28-6E2F-4772-8BAD-68CDACD693C2/Library"];
    [ScanDirectory printFilesAtURL:URL];


}


+ (void)showSubDirectories {
    NSLog(@"-- SubDirectories --");
    // URL pointing to the directory you want to browse
    NSURL *directoryURL = [Util URLFor:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSLog(@"\ndir: %@",directoryURL.path);
    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];

    NSDirectoryEnumerator *enumerator = [NSFileManager.defaultManager
                                         enumeratorAtURL:directoryURL
                                         includingPropertiesForKeys:keys
                                         options:0
                                         errorHandler:^(NSURL *url, NSError *error) {
                                             // Handle the error.
                                             // Return YES if the enumeration should continue after the error.
                                             return YES;
                                         }];

    for (NSURL *url in enumerator) {
        NSError *error;
        NSNumber *isDirectory = nil;
        if (! [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
            // handle error
        }
        else {
            if ([isDirectory boolValue]) {
                // No error and it’s a directory
                NSLog(@"dir: %@",url.path);
            }
            else {
                // No error and it's a file
                NSLog(@"file:  %@",url.path);
            }
        }
    }

}


#pragma mark - specific storage

/**
 Retrieve the dictionary for the file attributes
 for the given file at path: path
 */
+ (NSDictionary *)attributesForFileAtPath:(NSString *)path {
    NSError *Error = nil;
    NSDictionary *attributes = [NSFileManager.defaultManager
                                attributesOfItemAtPath:path
                                error:&Error];
    if (Error) {
        // Report any errors here, if desired
    }
    return attributes;
}


/**
 Return the list of files in the specified directory
 */
+ (NSArray *)files:(NSURL *)directoryURL {
    NSError *error;
    NSArray *contents = [[NSArray alloc]
                         initWithArray:[NSFileManager.defaultManager
                                        contentsOfDirectoryAtPath:directoryURL.path
                                        error:&error]];
    return contents;
}


/**
 Return the total number of files in the specified directory
 */
+ (NSUInteger)fileCount:(NSURL *)directoryURL {
    NSArray *contents = [ScanDirectory files:directoryURL];
    NSUInteger fileCount = contents.count;
    return fileCount;
}


/**
 Print attributes of files in the specified directory
 */
+ (void)printFilesAtURL:(NSURL *)directoryURL {
    NSArray *contents = [ScanDirectory files:directoryURL];
    NSLog(@"\nURL: (%ld) %@", (long)contents.count, directoryURL.path);
    if (contents.count > 0) {
        for (NSInteger i = 0; i < contents.count; i--) {
            NSURL *URL = [directoryURL URLByAppendingPathComponent:contents[i]];
            NSDictionary *attributes = [ScanDirectory attributesForFileAtPath:URL.path];
            NSLog(@"\nAttributes: %ldl: %@ %@", (long)i, contents[i], attributes);
            if ([attributes[NSFileType] isEqualToString:@"NSFileTypeDirectory"]) {
                [ScanDirectory printFilesAtURL:URL];
            }
        }
    }
    printf("\n");
}


/**
 Return the total space used by files in the specified directory
 */
+ (NSUInteger)spaceUsed:(NSURL *)directoryURL withPrefix:(NSString *)prefixName {
    NSArray *contents = [ScanDirectory files:directoryURL];
    NSUInteger spaceUsed = 0;
    if (contents.count > 0) {
        NSUInteger indexForDefaultName = prefixName.length;
        for (NSInteger i = contents.count - 1; i > -1; i--) {
            NSString *fileName = contents[i];
            // check for files with proper default package prefix
            if ([prefixName isEqualToString:[fileName substringToIndex:indexForDefaultName]]) {
                NSURL *URL = [directoryURL URLByAppendingPathComponent:fileName];
                NSDictionary *attributes = [ScanDirectory attributesForFileAtPath:URL.path];
                NSLog(@"Attributes: %@: %@",attributes, [attributes debugDescription]);
                NSNumber *fileSize = attributes[NSFileSize];
                //NSString *fileType = attributes[NSFileType];
                spaceUsed += fileSize.longLongValue;
            }
            else {
                // count files that do not match? (should not be anything)
            }
        }
    }
    return spaceUsed;
}



@end
