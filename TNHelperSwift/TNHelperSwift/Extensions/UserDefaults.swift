//
//  UserDefaultsType.swift
//  TNHelperSwift
//
//  Created by Nallamothu Tharun Kumar on 6/24/19.
//  Copyright © 2019 ATT CDO. All rights reserved.
//

import Foundation

public protocol UserDefaultsType: class {
    func string(forKey defaultName: String) -> String?
    func object(forKey defaultName: String) -> Any?
    func set(_ value: Any?, forKey defaultName: String)
}

private enum Key {
    static let dismissedAppWideMessage = "dismissedAppWideMessage"
    static let timeAppWideMessageWasDismissed = "timeAppWideMessageWasDismissed"
}

extension UserDefaultsType {
    var dismissedAppWideMessage: String? {
        get {
            return string(forKey: Key.dismissedAppWideMessage)
        }
        set {
            set(newValue, forKey: Key.dismissedAppWideMessage)
        }
    }
    
    var timeAppWideMessageWasDismissed: Date? {
        get {
            return object(forKey: Key.timeAppWideMessageWasDismissed) as? Date
        }
        set {
            set(newValue, forKey: Key.timeAppWideMessageWasDismissed)
        }
    }
}

extension UserDefaults: UserDefaultsType {}
