//
//  Validator+TN.swift
//  TNHelperSwift
//
//  Created by Nallamothu Tharun Kumar on 6/24/19.
//  Copyright © 2019 ATT CDO. All rights reserved.
//

import UIKit
import MapKit

extension MKMapView {
    
    public func topRightCorner() -> CLLocationCoordinate2D {
        let nePoint = CGPoint(x: bounds.origin.x + bounds.size.width, y: bounds.origin.y);
        return convert(nePoint, toCoordinateFrom: self)
    }
    
    public func bottomLeftCorner() -> CLLocationCoordinate2D {
        let swPoint = CGPoint(x: bounds.origin.x, y: (bounds.origin.y + bounds.size.height));
        return convert(swPoint, toCoordinateFrom: self)
    }
    
    public func topRightLocation() -> CLLocation {
        let nePoint = topRightCorner()
        return CLLocation(latitude: nePoint.latitude, longitude: nePoint.longitude)
    }
    
    public func bottomLeftLocation() -> CLLocation {
        let swPoint = bottomLeftCorner()
        return CLLocation(latitude: swPoint.latitude, longitude: swPoint.longitude)
    }
}
