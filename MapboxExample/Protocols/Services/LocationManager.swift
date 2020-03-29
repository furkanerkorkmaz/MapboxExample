//
//  LocationManager.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 28.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManager {
    
    var isLocationEnabled: Bool { get }
    func fetcthUserLocation(completion: @escaping UserLocationCompletion)

}
