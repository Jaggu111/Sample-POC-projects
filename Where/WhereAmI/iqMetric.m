//
//  iqMetric.m
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

#import "iqMetric.h"

@implementation iqMetric

/*!
 *  @method metricId
 *  @abstract   subclass this method to set the proper metric ID
 *
 */
- (iq_metric_id_t)metricId {
    return IQ_MAKE_ID('?','?','?','?');
}

- (NSString *)description {
    return @"";
}

@end
