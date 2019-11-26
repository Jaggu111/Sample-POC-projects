//
//  NotificationCenter.swift
//  TNHelperSwift
//
//  Created by Nallamothu Tharun Kumar on 6/24/19.
//  Copyright © 2019 ATT CDO. All rights reserved.
//

import Foundation

public protocol NotificationCenterType: class {
    func addObserver(forName name: NSNotification.Name?,
                     object obj: Any?,
                     queue: OperationQueue?,
                     using block: @escaping (Notification) -> Void) -> NSObjectProtocol
    func removeObserver(_ observer: Any)
}

extension NotificationCenter: NotificationCenterType {}
