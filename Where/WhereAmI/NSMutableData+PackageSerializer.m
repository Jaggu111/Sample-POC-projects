//
//  NSMutableData+PackageSerializer.m
//  PackageGenerator
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

#import "NSMutableData+PackageSerializer.h"

@implementation NSMutableData (PackageSerializer)

- (void) appendUint8:(uint8_t)value
{
    [self appendBytes:&value length:sizeof(value)];
}

- (void) appendMyCString:(NSString *)value
{
    // add one to include the terminating null
    if (value) {
        [self appendBytes:[value UTF8String] length:strlen([value UTF8String])+1];
    }
    else {
        [self appendBytes:"" length:1];
    }
}


@end
