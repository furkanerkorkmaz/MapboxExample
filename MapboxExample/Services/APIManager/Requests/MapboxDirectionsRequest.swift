//
//  MapboxDirectionsRequest.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 29.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

// MARK: Routes
  private enum MapboxDirectionsRoutes: String {

      case drivingDirections = "directions/v5/mapbox/driving/%@?geometries=%@&access_token=%@"
      
      func endpoint(with arguments: CVarArg...) -> String {
          return String(format: self.rawValue, arguments: arguments)
      }
      
  }

struct MapboxDirectionsRequest {

    private let coordinates: [CLLocationCoordinate2D]

    // MARK: - Init/Deinit
    init(coordinates: [CLLocationCoordinate2D]) {
        self.coordinates = coordinates
    }
    
}

// MARK: - NetworkRequest
extension MapboxDirectionsRequest: NetworkRequest {

    var path: String {
        let coordinates = self.coordinates.compactMap({ "\($0.longitude)" + "," + "\($0.latitude)" }).joined(separator: ";")
        var pathString = AppConfig.mapboxApiBaseUrl
            pathString += MapboxDirectionsRoutes.drivingDirections.endpoint(with: coordinates, "geojson", AppConfig.mapboxPublicToken)
        return pathString
    }

    var method: HTTPMethod {
        return .get
    }

    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }

    var headers: [String: String] {
        let result: [String: String] = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        return result
    }

}
