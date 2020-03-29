//
//  Typealiases.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 28.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation
import CoreLocation

typealias EmptyClosure = () -> Void
typealias ErrorCompletion = (_ error: ApplicationError?) -> Void
typealias TaskFinishedCompletion = (_ isFinished : Bool) -> Void
typealias UserLocationCompletion = (_ currentLocation: CLLocation?, _ error: ApplicationError?) -> Void
typealias DriveDirectionsCompletion = (_ driveDirections: MapboxDirectionModel?, _ error: ApplicationError?) -> Void
