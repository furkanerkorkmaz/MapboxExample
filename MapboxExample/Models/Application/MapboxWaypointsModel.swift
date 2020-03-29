//
//  MapboxWaypointsModel.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 29.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

struct MapboxWaypointsModel: Codable {

    var distance: Double?
    var name: String?
    var location: [Double]?

}

extension MapboxWaypointsModel {
    
    var locationCoordinates: CLLocationCoordinate2D? {
        guard let latitude = location?.last, let longitude = location?.first else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}


extension MapboxWaypointsModel: EntityConvertible {
    
    typealias Entity = CDMapboxWaypoints
    
    static var entityName: String {
        return "CDMapboxWaypoints"
    }

    var entityName: String? {
        return CDMapboxWaypoints.entity().name
    }
    
    init(entity: CDMapboxWaypoints) {
        distance = entity.distance
        name = entity.name
        location = entity.location
    }
    
    func convertToEntity(for context: NSManagedObjectContext) throws -> CDMapboxWaypoints {
        let entity = CDMapboxWaypoints(context: context)
        entity.distance = distance ?? 0
        entity.name = name
        entity.location = location
        return entity
    }
    
}
