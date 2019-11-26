//
//  iqDefs.h
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

#ifndef iqDefs_h
#define iqDefs_h

// iq types

typedef uint32_t iq_metric_id_t;

// convenience to make 4-byte trigger and metric names

#define IQ_MAKE_ID( a, b, c, d ) ( ((iq_metric_id_t)(a) << 24) | ((iq_metric_id_t)(b) << 16) | ((iq_metric_id_t)(c) << 8) | ((iq_metric_id_t)(d)) )

#define IQ_LIGHTWEIGHT_PACKAGE_TRIGGER  IQ_MAKE_ID('U','P','T','R')

// Upload Server

#define PILOT_PACKAGE_UPLOAD_SERVER     @"https://iqp01.ciq.labs.att.com:10010/collector/c"
#define RAINBOW_PACKAGE_UPLOAD_SERVER   @"https://collector1.sky.carrieriq.com/collector/c"
#define OTA_PACKAGE_UPLOAD_SERVER       @"https://col01.iqi.labs.att.com:10020/collector/c"

// Use OTA server for lightweight projects
#define PACKAGE_UPLOAD_SERVER           OTA_PACKAGE_UPLOAD_SERVER

// Unique string for background uploading (allows for continuing an upload)

#define IQ_BACKGROUND_UPLOAD_ID         @"com.att.mobile.iqi"

// Directory Names

#define IQ_PRIVATE_DIRECTORY            @"com.att.mobile.iqi"
#define IQ_PACKAGE_DIRECTORY            @"Packages"
#define IQ_METRICS_DIRECTORY            @"Metrics"

// Default package file name
#define DEFAULT_PACKAGE_FILE_NAME       @"iqiLightweightPackge"

//  Access items in the bundle via:
//      [[NSBundle mainBundle] objectForInfoDictionaryKey:KEY];
//  Strings will use NSString *
//      other objects are possible, eg. NSDictionary, NSArray
//

#define BUNDLE_KEY_PACKAGE_UPLOAD_SERVER    @"IQI_Upload_Server_Name"
#define BUNDLE_KEY_IQ_BACKGROUND_UPLOAD_ID  @"IQI_Background_Upload_Id"

#define BUNDLE_KEY_IQ_PRIVATE_DIRECTORY     @"IQI_Private_Directory_Name"
#define BUNDLE_KEY_IQ_PACKAGE_DIRECTORY     @"IQI_Package_Directory_Name"
#define BUNDLE_KEY_IQ_METRICS_DIRECTORY     @"IQI_Metrics_Directory_Name"

#endif /* iqDefs_h */
