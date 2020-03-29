//
//  MapboxRouteModel.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 29.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation
import CoreData

struct MapboxRouteModel: Codable {
    
    var weightName: String?
    var legs: [MapboxLegsModel]?
    var geometry: MapboxGeometryModel?
    var distance: Double?
    var duration: Double?
    var weight: Double?

    // MARK: - Codable Protocol
    private enum CodingKeys: String, CodingKey {
        case weightName = "weight_name"
        case legs
        case geometry
        case distance
        case duration
        case weight
    }
    
}

extension MapboxRouteModel: EntityConvertible {
    
    typealias Entity = CDMapboxRouteModel
    
    static var entityName: String {
        return "CDMapboxRouteModel"
    }

    var entityName: String? {
        return CDMapboxRouteModel.entity().name
    }

    init(entity: CDMapboxRouteModel) {
        weightName = entity.weightName
        legs = []
        entity.legs?.forEach { (legsObj) in
            if let legsObj = legsObj as? CDMapboxLegsModel {
                legs?.append(MapboxLegsModel(entity: legsObj))
            }
        }
        if let cdGeometry = entity.geometry {
            geometry = MapboxGeometryModel(entity: cdGeometry)
        }
        distance = entity.distance
        duration = entity.duration
        weight = entity.weight
    }
    
    func convertToEntity(for context: NSManagedObjectContext) throws -> CDMapboxRouteModel {
        let entity = CDMapboxRouteModel(context: context)
        entity.weightName = weightName
        legs?.forEach({ (legs) in
            if let cdLegs = try? legs.convertToEntity(for: context) {
                entity.addToLegs(cdLegs)
            }
        })
        entity.geometry = try? geometry?.convertToEntity(for: context)
        entity.distance = distance ?? 0
        entity.duration = duration ?? 0
        entity.weight = weight ?? 0
        return entity
    }
    
}
