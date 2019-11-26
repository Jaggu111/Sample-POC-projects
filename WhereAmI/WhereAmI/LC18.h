//
//  LC18.h
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
#import <CoreLocation/CoreLocation.h>

@interface LC18 : iqMetric <CLLocationManagerDelegate>

typedef void (^VisitCompletionBlock)(CLVisit *visit);

- (CLLocation *)myLocation;
- (void)setGPSPolling:(BOOL)state;
- (void)enableVisitsWithCompletion:(VisitCompletionBlock)finishBlock;
- (void)disableVisits;
- (NSMutableArray *)myVisits;


@end
