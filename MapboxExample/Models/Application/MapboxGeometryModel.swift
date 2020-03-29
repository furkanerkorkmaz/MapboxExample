//
//  MapboxGeometryModel.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 29.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

struct MapboxGeometryModel: Codable {

    var coordinates: [[Double]]?
    var type: String?

}

extension MapboxGeometryModel {
    
    var routeCoordinates: [CLLocationCoordinate2D]? {
        var routeCoordinates: [CLLocationCoordinate2D] = []
        coordinates?.forEach({ (coordinates) in
            guard let latitude = coordinates.last, let longitude = coordinates.first else {
                return
            }
            routeCoordinates.append(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        })
        return routeCoordinates
    }
    
}

extension MapboxGeometryModel: EntityConvertible {
    
    typealias Entity = CDMapboxGeometryModel
    
    static var entityName: String {
        return "CDMapboxGeometryModel"
    }

    var entityName: String? {
        return CDMapboxGeometryModel.entity().name
    }

    init(entity: CDMapboxGeometryModel) {
        type = entity.type
        coordinates = entity.coordinates
    }
    
    func convertToEntity(for context: NSManagedObjectContext) throws -> CDMapboxGeometryModel {
        let entity = CDMapboxGeometryModel(context: context)
        entity.type = type
        entity.coordinates = coordinates
        return entity
    }
    
}
