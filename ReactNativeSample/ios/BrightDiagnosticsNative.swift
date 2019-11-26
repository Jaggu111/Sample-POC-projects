//
//  BrightDiagnosticsNative.m
//  ReactNativeSample
//
//  Created by Nallamothu Tharun Kumar on 11/16/19.
//  Copyright © 2019 ATT. All rights reserved.
//

import Foundation
import UIKit

@objc(BrightDiagnosticsNative)
class BrightDiagnosticsNative: NSObject {
   @objc
  static var vendorID = UIDevice.current.identifierForVendor?.uuidString
  
  @objc
  func enableSDK() {
    
  }
  
  @objc
  func disableSDK() {
    
  }
  
  @objc
  func collect() {
    
  }
  
  @objc
  func getVendorID(_ callback: RCTResponseSenderBlock) {
    callback([NSNull(), BrightDiagnosticsNative.vendorID ?? ""])
    print(BrightDiagnosticsNative.vendorID!)
  }

  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }
}
