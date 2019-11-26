//
//  ScanDirectory.h
//  DirectorySearch
//
//  Created by Carl a Baltrunas on 3/28/19.
//  Copyright © 2019 AT&T CDO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScanDirectory : NSObject

+ (void)showTopLevelDirectories;
+ (void)showSubDirectories;

#pragma mark - specific storage

/**
 Retrieve the dictionary for the file attributes
 for the given file at path: path
 */
+ (NSDictionary *)attributesForFileAtPath:(NSString *)path;


/**
 Return the list of files in the specified directory
 */
+ (NSArray *)files:(NSURL *)directoryURL;


/**
 Return the total number of files in the specified directory
 */
+ (NSUInteger)fileCount:(NSURL *)directoryURL;


/**
 Print attributes of files in the specified directory
 */
+ (void)printFilesAtURL:(NSURL *)directoryURL;


/**
 Return the total space used by files in the specified directory
 */
+ (NSUInteger)spaceUsed:(NSURL *)directoryURL withPrefix:(NSString *)prefixName;


@end

NS_ASSUME_NONNULL_END

