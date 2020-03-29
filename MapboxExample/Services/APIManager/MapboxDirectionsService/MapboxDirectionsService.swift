//
//  MapboxDirectionsService.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 29.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation
import CoreLocation

final class MapboxDirectionsService {

    private let apiManager: NetworkDataProvider

    // MARK: - Init/Deinit
    init(apiManager: NetworkDataProvider = APIManager()) {
        self.apiManager = apiManager
    }

}

// MARK: - MapboxDirectionsModule
extension MapboxDirectionsService: MapboxDirectionsModule {

    func fetctDriveDirections(by coordinates: [CLLocationCoordinate2D], completionHandler: @escaping DriveDirectionsCompletion) {
        let request: NetworkRequest = MapboxDirectionsRequest(coordinates: coordinates)
        apiManager.request(request, parser: CodableParser<MapboxDirectionModel>()) { response in
            guard let result = response.responseObject, response.error == nil else {
                completionHandler(nil, response.error)
                return
            }
            completionHandler(result as? MapboxDirectionModel, response.error)
        }
    }
}
