//
//  MapboxDirectionModel.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 29.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation
import CoreData

struct MapboxDirectionModel: Codable {
    
    var routes: [MapboxRouteModel]?
    var waypoints: [MapboxWaypointsModel]?
    let code: String?
    let uuid: String?
        
}

extension MapboxDirectionModel: EntityConvertible {
    
    typealias Entity = CDMapboxDirectionModel
    
    static var entityName: String {
        return "CDMapboxDirectionModel"
    }

    var entityName: String? {
        return CDMapboxDirectionModel.entity().name
    }
    
    init(entity: CDMapboxDirectionModel) {
        code = entity.code
        uuid = entity.uuid
        routes = []
        entity.routes?.forEach { (routesObj) in
            if let routesObj = routesObj as? CDMapboxRouteModel {
                routes?.append(MapboxRouteModel(entity: routesObj))
            }
        }
        waypoints = []
        entity.waypoints?.forEach { (waypointsObj) in
            if let waypointsObj = waypointsObj as? CDMapboxWaypoints {
                waypoints?.append(MapboxWaypointsModel(entity: waypointsObj))
            }
        }
    }
    
    func convertToEntity(for context: NSManagedObjectContext) throws -> CDMapboxDirectionModel {
        let entity = CDMapboxDirectionModel(context: context)
        routes?.forEach({ (routes) in
            if let cdRoute = try? routes.convertToEntity(for: context) {
                entity.addToRoutes(cdRoute)
            }
        })
        waypoints?.forEach({ (waypoints) in
            if let cdWaypoints = try? waypoints.convertToEntity(for: context) {
                entity.addToWaypoints(cdWaypoints)
            }
        })
        entity.code = code
        entity.uuid = uuid
        return entity
    }
    
}
