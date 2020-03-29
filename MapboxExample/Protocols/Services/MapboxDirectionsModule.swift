//
//  MapboxDirectionsModule.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 29.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation
import CoreLocation

protocol MapboxDirectionsModule {
    
    func fetctDriveDirections(by coordinates: [CLLocationCoordinate2D], completionHandler: @escaping DriveDirectionsCompletion)

}
