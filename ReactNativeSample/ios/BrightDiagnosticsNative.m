//
//  BrightDiagnosticsNative.m
//  ReactNativeSample
//
//  Created by Nallamothu Tharun Kumar on 11/16/19.
//  Copyright © 2019 ATT. All rights reserved.
//

#import "React/RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(BrightDiagnosticsNative, NSObject)
RCT_EXTERN_METHOD(enableSDK)
RCT_EXTERN_METHOD(disableSDK)
RCT_EXTERN_METHOD(collect)
RCT_EXTERN_METHOD(getVendorID: (RCTResponseSenderBlock)callback)
@end
