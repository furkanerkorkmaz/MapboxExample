//
//  MapboxLegsModel.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 29.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation
import CoreData

struct MapboxLegsModel: Codable {

    var summary: String?
    var distance: Double?
    var duration: Double?
    var weight: Double?

}

extension MapboxLegsModel: EntityConvertible {
    
    typealias Entity = CDMapboxLegsModel
    
    static var entityName: String {
        return "CDMapboxLegsModel"
    }

    var entityName: String? {
        return CDMapboxLegsModel.entity().name
    }

    init(entity: CDMapboxLegsModel) {
        summary = entity.summary
        distance = entity.distance
        duration = entity.duration
        weight = entity.weight
    }
    
    func convertToEntity(for context: NSManagedObjectContext) throws -> CDMapboxLegsModel {
        let entity = CDMapboxLegsModel(context: context)
        entity.summary = summary
        entity.distance = distance ?? 0
        entity.duration = duration ?? 0
        entity.weight = weight ?? 0
        return entity
    }
    
}
