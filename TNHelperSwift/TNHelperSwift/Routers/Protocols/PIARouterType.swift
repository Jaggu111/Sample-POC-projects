//
//  PIARouterType.swift
//  Bluprint
//
//  Created by Robert Cole on 11/19/18.
//  Copyright © 2018 Bluprint. All rights reserved.
//

import UIKit

public protocol PIARouterType: Presentable {
    func presentInPIA(_ content: PIAContent)
    func dismissPIA(direction: SwipeDirection)
}
