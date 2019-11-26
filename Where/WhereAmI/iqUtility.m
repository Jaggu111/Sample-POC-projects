//
//  iqUtility.m
//  iqiSDK
//
// **********************************************************************************
// *                                                                                *
// *    Copyright (c) 2017 AT&T Intellectual Property. ALL RIGHTS RESERVED          *
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

#import <UIKit/UIApplication.h>
#import "iqUtility.h"
#import "iqDefs.h"

@implementation iqUtility

// none of these values change during the execution of the application
// cache them here and if non-null, return cached values

static NSURL *iqDocuments = nil;        // default Documents directory url
static NSURL *iqLibrary = nil;          // default Library directory url

static NSURL *iqPrivate = nil;          // private iq documents directory url
static NSURL *iqPackage = nil;          // private iq packages directory url
static NSURL *iqMetrics = nil;          // private iq metrics directory url

/*!
 *  @method bundleObject
 *  @abstract   convenience method to return an objectr from the main bundle
 *              if the field is found, its object will be returned
 *              most fields contain strings
 *              they can contain any type of object:
 *                  numeric, array, dictionary, or complex structures
 *
 */
+ (id)bundleObject:(NSString *)bundleField {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:bundleField];
}

/*!
 *  @method documentsURL
 *  @abstract   get URL of documents directory
 *
 */
+ (NSURL *)documentsURL {
    if (!iqDocuments) {
        iqDocuments = [[[NSFileManager defaultManager]
                         URLsForDirectory:NSDocumentDirectory
                         inDomains:NSUserDomainMask]
                        firstObject];
    }
    return iqDocuments;
}

/*!
 *  @method libraryURL
 *  @abstract   get URL of library directory
 *
 */
+ (NSURL *)libraryURL {
    if (!iqLibrary) {
        iqLibrary = [[[NSFileManager defaultManager]
                         URLsForDirectory:NSLibraryDirectory
                         inDomains:NSUserDomainMask]
                        firstObject];
    }
    return iqLibrary;
}

/*!
 *  @method iqPrivateURL
 *  @abstract   get URL of private iq documents directory
 *              if definition found in application bundle use it
 *              otherwise use default value
 *
 */
+ (NSURL *)iqPrivateURL {
    if (!iqPrivate) {
        NSString *urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:BUNDLE_KEY_IQ_PRIVATE_DIRECTORY];
        if (!urlString) {
            urlString = IQ_PRIVATE_DIRECTORY;
        }
        iqPrivate = [[iqUtility libraryURL] URLByAppendingPathComponent:urlString];
    }
    return iqPrivate;
}

/*!
 *  @method iqPackageURL
 *  @abstract   get URL of private iqPackage directory
 *              if definition found in application bundle use it
 *              otherwise use default value
 *
 */
+ (NSURL *)iqPackageURL {
    if (!iqPackage) {
        NSString *urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:BUNDLE_KEY_IQ_PACKAGE_DIRECTORY];
        if (!urlString) {
            urlString = IQ_PACKAGE_DIRECTORY;
        }
        iqPackage = [[iqUtility iqPrivateURL] URLByAppendingPathComponent:urlString];
    }
    return iqPackage;
}

/*!
 *  @method iqMetricsURL
 *  @abstract   get URL of private iqMetrics directory
 *              if definition found in application bundle use it
 *              otherwise use default value
 *
 */
+ (NSURL *)iqMetricsURL {
    if (!iqMetrics) {
        NSString *urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:BUNDLE_KEY_IQ_METRICS_DIRECTORY];
        if (!urlString) {
            urlString = IQ_METRICS_DIRECTORY;
        }
        iqMetrics = [[iqUtility iqPrivateURL] URLByAppendingPathComponent:urlString];
    }
    return iqMetrics;
}

/*!
 *  @method getNextPackageName
 *  @abstract   get next package fileName
 *
 */
+ (NSString *)nextPackageName {
    return DEFAULT_PACKAGE_FILE_NAME;
}

/*!
 *  @method removePackageName
 *  @abstract   remove the file for a package fileName
 *
 */
+ (void)removePackageName:(NSString *)fileName {
    NSError *removeError = nil;
    [[NSFileManager defaultManager] removeItemAtURL:[[iqUtility iqPackageURL] URLByAppendingPathComponent:fileName] error:&removeError];
    if (removeError) {
        NSLog(@"%s Error: %@", __FUNCTION__, removeError);
    }
}

/*!
 *  @method setupPackageDirectory
 *  @abstract   make sure that the iqPackageDirectory exists
 *              initial version has no error checking
 *              errors may occur if device disk is full
 *              or if device is locked(?)
 *              add check or some protection before release ***
 *
 */
+ (void)setupPackageDirectory {
    [[NSFileManager defaultManager]
     createDirectoryAtURL:[iqUtility iqPackageURL] withIntermediateDirectories:YES
     attributes:nil
     error:nil];
}

/*!
 *  @method packageFileList
 *  @abstract   get list of packages
 *
 */
+ (NSArray *)iqPackageFileList {
    if (false) {
        // code here to check for existence of the package directory
        // if it has not been created yet
        return nil;
    }
    // currently providing return of success or failure, not the reason for failure
    // may want to update this before release ***
    NSError *error;
    return [[NSFileManager defaultManager]
            contentsOfDirectoryAtPath:[[iqUtility iqPackageURL] path] error:&error];
}

/*!
 *  @method notInBackground
 *  @abstract   return whether the app is active or not
 *              UIApplicationStateActive == foreground active
 *              UIApplicationStateInactive == foreground not receiving events
 *              UIApplicationStateBackground == background
 *
 */
+ (BOOL)isActive {
    NSLog(@"%s: %ld (%ld %ld %ld)", __func__,(long)[[UIApplication sharedApplication] applicationState], (long)UIApplicationStateActive, (long)UIApplicationStateInactive, (long)UIApplicationStateBackground);
    return ([[UIApplication sharedApplication]applicationState] == UIApplicationStateActive);
}


@end
