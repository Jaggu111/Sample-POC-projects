//
//  BRTImages.m
//  plcrashtest
//
//  Created by Carl a Baltrunas on 5/6/19.
//  Copyright © 2019 AT&T CDO. All rights reserved.
//

#import "BRTImages.h"
#import "BRTCrashReporter.h"
#import "BRTImage.h"


@interface BRTImages ()

@property (nonatomic, strong) NSMutableDictionary *imageInfo;
@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation BRTImages


#pragma mark - shared init

static BRTImages *_sharedInstance = nil;


+ (BRTImages *)shared {
    static dispatch_once_t _once_token = 0;
    dispatch_once(&_once_token, ^{
        _sharedInstance = [[BRTImages alloc] init];
    });

    // do anything that needs to be done outside of once
    return _sharedInstance;
}

- (instancetype)init {
    if (_sharedInstance) {
        return _sharedInstance;
    }

    self = [super init];
    if (self) {
        _imageInfo = [NSMutableDictionary dictionary];
        _imageArray = [NSMutableArray array];
    }
    return self;
}


#pragma mark - utility methods to adjust image information

+ (void)fixupImage:(PLCrashReportBinaryImageInfo *)image {
    NSRange range;
    NSUInteger index;

//    // clear our fields
//    image.isApp = NO;
//    image.isInApp = NO;
//    image.isSystem = NO;
//    image.isPrivate = NO;
//    image.isDevice = NO;
//    image.isSimulator = NO;

    // copy for frequent usage
    NSString *name = image.imageName;

//    // set shortname (not guaranteed to be unique)
//    image.imageShortName = [name lastPathComponent];


//    image.imageMiddleName = [self middleName:image.imageName];

    // if we are a simulatgor, remove leading simulator stuff
    if ([name containsString:@"/Resources/RuntimeRoot/"]) {
//        image.isSimulator = YES;
//        image.isSystem = YES;
//        name = image.imageMiddleName;
    }
    else {
//        image.isDevice = YES;
    }

    if ([name containsString:@"/System/Library/PrivateFrameworks"]) {
        range = [name rangeOfString:@"/System/Library"];
        if (range.location == 0) {
//            image.isSystem = YES;
        }
//        image.isPrivate = YES;
//        image.isFramework = YES;
    }
    else if ([name containsString:@"/System/Library/Frameworks"]) {
        range = [name rangeOfString:@"/System/Library"];
        if (range.location == 0) {
//            image.isSystem = YES;
        }
//        image.isFramework = YES;
    }
    else if ([name containsString:@"/usr/lib"]) {
        range = [name rangeOfString:@"/usr/lib"];
        if (range.location == 0) {
//            image.isSystem = YES;
        }
//        image.isLibrary = YES;
    }
    else if ([name containsString:@"/Frameworks"]) {
//        image.isFramework = YES;
    }
    else if ([name containsString:@".app/"]) {
        range = [name rangeOfString:@".app/"];
        index = range.location + range.length;
        NSString *appname = [name substringFromIndex:index];
        if (range.location >= appname.length) {
            index = range.location - appname.length;
            range.location = index;
            range.length = appname.length;
            NSString *myAppname = [name substringWithRange:range];
            if ([appname isEqualToString:myAppname]) {
//                image.isApp = YES;
            }
        }
//        image.isInApp = YES;
    }
//    else if ([name containsString:@"/var"]) {
//        image.isDevice = YES;
//    }
}


#pragma mark - methods for sorting images and finding image address

/**
 *  given an address, return the array index to insert
 *  the given image, such that the item at this address
 *  has a base addres greater than the specified address
 *
 *  when searching for a place to insert an image, this
 *  index will point to the next highest image (if any)
 *
 *  when searching for an image that contains the address
 *  if index is not 0, index-1 "may" contain the address
 *
 *  if index is 0, either there are no images, or
 *  the address is lower than the first image in the array
 *
 */

+ (NSUInteger)searchForAddress:(uint64_t)address
                     usingBase:(NSUInteger)base
                        andTop:(NSUInteger)top {
    // if we've collapsed to the lower bound, just return it
    if (base == top) {
        return base;
    }

    NSUInteger count = _sharedInstance.imageArray.count;
    // if first entry, just return 0
    if (count == 0) {
        return 0;
    }

    // set search item between base and top
    NSUInteger search = ((base + top) / 2);

    // get our current search image
    PLCrashReportBinaryImageInfo *image = nil;
    image = _sharedInstance.imageArray[search];
    if (address < image.imageBaseAddress) {
        if (search == base) {
            // edge case at base, return base
            return base;
        }
        else {
            // check next iteration between base and search
            return [self searchForAddress:address usingBase:base andTop:search];
        }
    }
    else {
        if (search == (top - 1)) {
            // edge case at top, return top
            // will be next place to add an image
            return top;
        }
        else {
            // check next iteration between search and top
            return [self searchForAddress:address usingBase:search andTop:top];
        }
    }
}

+ (PLCrashReportBinaryImageInfo *)imageForAddress:(uint64_t)address {
    // should never happen, but always check if array is nil
    if (_sharedInstance.imageArray) {
        @synchronized(_sharedInstance.imageArray) {
            NSUInteger index;
            index = [self searchForAddress:address
                                 usingBase:0
                                    andTop:_sharedInstance.imageArray.count];

            if (index <= _sharedInstance.imageArray.count) {
                PLCrashReportBinaryImageInfo *image = _sharedInstance.imageArray[index];
                uint64_t baseAddress = image.imageBaseAddress;
                uint64_t size = image.imageSize;
                if ((address >= baseAddress) && (address < (baseAddress + size))) {
                    NSLog(@"0x%llx in 0x%llx 0x%llx %@",
                          address, baseAddress, size, [image.imageName lastPathComponent]);
                    return image;
                }
            }
        }
    }
    return nil;
}


+ (void)insertImageInArray:(PLCrashReportBinaryImageInfo *)image {
    // modified insertion sort
    if (!image) {
        return;
    }
    // should never happen, but always check if array is nil
    if (_sharedInstance.imageArray) {
        @synchronized(_sharedInstance.imageArray) {
            NSUInteger index;
            index = [self searchForAddress:image.imageBaseAddress
                                 usingBase:0
                                    andTop:_sharedInstance.imageArray.count];

            if (index <= _sharedInstance.imageArray.count) {
                [_sharedInstance.imageArray insertObject:image atIndex:index];
            }
//            NSLog(@"");
//            NSLog(@"");
//            NSLog(@"Count: %ld", _sharedInstance.imageArray.count);
//            NSLog(@"");
//            for (PLCrashReportBinaryImageInfo *image in _sharedInstance.imageArray) {
//                NSLog(@"0x%llx : 0x%07llx -- %@",
//                      image.imageBaseAddress,
//                      image.imageSize,
//                      [image.imageName lastPathComponent]);
//            }
//            NSLog(@"");
        }
    }
}

+ (BOOL)setupImagesUsing:(NSArray *)binaryImages {
    if (binaryImages && binaryImages.count > 0) {
        if (!self.shared.imageArray) {
            // should never happen
            return NO;
        }
        // if we are calling this again, reset array
        if (self.shared.imageArray.count > 0) {
            self.shared.imageArray = [NSMutableArray array];
        }

        // now get to work
        for (PLCrashReportBinaryImageInfo *image in binaryImages) {
            [self fixupImage:image];
            [self insertImageInArray:image];

//            NSLog(@"Name %@ 0x%llx x%llx",
////                  image.isApp ? "A" : " ",
////                  image.isInApp ? "I" : " ",
////                  image.isSystem ? "S" : " ",
////                  image.isPrivate ? "P" : " ",
////                  image.isDevice ? "D" : " ",
////                  image.isSimulator ? "S" : " ",
////                  image.hasImageUUID ? "U" : " ",
//                  [image.imageName lastPathComponent],
//                  image.imageBaseAddress,
//                  image.imageSize);

//            NSLog(@"%s %s %s %s %s %s %s Name %@ 0x%llx x%llx",
//                  image.isApp ? "A" : " ",
//                  image.isInApp ? "I" : " ",
//                  image.isSystem ? "S" : " ",
//                  image.isPrivate ? "P" : " ",
//                  image.isDevice ? "D" : " ",
//                  image.isSimulator ? "S" : " ",
//                  image.hasImageUUID ? "U" : " ",
//                  image.imageMiddleName,
//                  image.imageBaseAddress,
//                  image.imageSize);

        }
        for (PLCrashReportBinaryImageInfo *image in binaryImages) {
//            NSLog(@"Name %@ 0x%llx x%llx",
//                  image.isApp ? "A" : " ",
//                  image.isInApp ? "I" : " ",
//                  image.isSystem ? "S" : " ",
//                  image.isPrivate ? "P" : " ",
//                  image.isDevice ? "D" : " ",
//                  image.isSimulator ? "S" : " ",
//                  image.hasImageUUID ? "U" : " ",
//                  [image.imageName lastPathComponent],
//                  image.imageBaseAddress,
//                  image.imageSize);
               NSLog(@"0x%llx : 0x%07llx -- %@",
                      image.imageBaseAddress,
                      image.imageSize,
                      [image.imageName lastPathComponent]);
        }
    }
    else {
        return NO;
    }
    return YES;
}


@end
