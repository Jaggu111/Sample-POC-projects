//
//  Util.h
//  DirectorySearch
//
//  Created by Carl a Baltrunas on 3/25/19.
//  Copyright © 2019 AT&T CDO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Util : NSObject

+ (NSURL *)documentsDirectoryURL;
+ (NSURL *)libraryDirectoryURL;
+ (NSURL *)URLFor:(NSSearchPathDirectory)directory
        inDomains:(NSSearchPathDomainMask)mask;

@end

NS_ASSUME_NONNULL_END
