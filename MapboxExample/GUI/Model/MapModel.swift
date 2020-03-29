//
//  MapModel.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 28.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

protocol MapModelProtocol: class {
    
    var selectedRouteCoordinates: [CLLocationCoordinate2D] { get }
    var currentRouteCoordinates: [CLLocationCoordinate2D]? { get }

    func append(coordinate: CLLocationCoordinate2D, completion: ErrorCompletion)
    func removeLastCoordinateAndFetchNewRoute(completion: @escaping DriveDirectionsCompletion)
    func clearRouteCoordinates(completion: @escaping TaskFinishedCompletion)
    func fetchRoute(completion: @escaping DriveDirectionsCompletion)

    func fetchStoredRoute(completion: @escaping DriveDirectionsCompletion)
    func saveRoute()
    
}

final class MapModel {

    private let locationManger: LocationManager
    private let apiManager: MapboxDirectionsService
    private let dbService: DataBaseService

    private var routeCoordinates: [CLLocationCoordinate2D] = []
    private var mapboxDirections: MapboxDirectionModel?

    var isInfoCollapsed: Bool = true

    // MARK: - Init/Deinit

    init(locationManager: LocationManager, apiManager: MapboxDirectionsService = MapboxDirectionsService(), dbService: DataBaseService = CoreDataService()) {
        self.locationManger = locationManager
        self.apiManager = apiManager
        self.dbService = dbService
    }
}

// MARK: - MapModelProtocol
extension MapModel: MapModelProtocol {
    
    var selectedRouteCoordinates: [CLLocationCoordinate2D] {
        return routeCoordinates
    }
    
    var currentRouteCoordinates: [CLLocationCoordinate2D]? {
        get {
            return self.mapboxDirections?.routes?.first?.geometry?.routeCoordinates
        }
    }
        
    func removeLastCoordinateAndFetchNewRoute(completion: @escaping DriveDirectionsCompletion) {
        if !routeCoordinates.isEmpty {
            routeCoordinates.removeLast()
            if routeCoordinates.count > 1 {
                fetchRoute(completion: completion)
                return
            }
        }
        mapboxDirections = nil
        completion(nil, nil)
    }
    
    func append(coordinate: CLLocationCoordinate2D, completion: ErrorCompletion) {
        if routeCoordinates.count >= Defines.maxRouteCoordinatesNumber {
            completion(ApplicationError.maxCoordinatesNumberReachedError)
            return
        }
        routeCoordinates.append(coordinate)
        completion(nil)
    }

    func clearRouteCoordinates(completion: @escaping TaskFinishedCompletion) {
        guard let mapboxDirections = mapboxDirections else {
            self.routeCoordinates.removeAll()
            completion(true)
            return
        }
        dbService.clearData(entity: mapboxDirections) { [weak self] (isFinished) in
            self?.routeCoordinates.removeAll()
            self?.mapboxDirections = nil
            completion(isFinished)
        }
    }
    
    func fetchRoute(completion: @escaping DriveDirectionsCompletion) {
        self.apiManager.fetctDriveDirections(by: self.routeCoordinates) { [weak self] (mapboxDirection, error) in
            self?.mapboxDirections = mapboxDirection
            completion(mapboxDirection, error)
        }
    }
 
    func fetchStoredRoute(completion: @escaping DriveDirectionsCompletion) {
        if let firstObject = dbService.fetchRecords(from: MapboxDirectionModel.entityName).first as? CDMapboxDirectionModel {
            self.mapboxDirections = MapboxDirectionModel.init(entity: firstObject)
            self.mapboxDirections?.waypoints?.forEach({ (waypoint) in
                if let coordinate = waypoint.locationCoordinates {
                    self.routeCoordinates.append(coordinate)
                }
            })
        }
        completion(nil, nil)
    }

    func saveRoute() {
        guard let mapboxDirections = mapboxDirections else {
            return
        }
        dbService.clearData(entity: mapboxDirections) { [weak self] (_) in
            self?.dbService.store(entity: mapboxDirections, saveContext: true, forThread: .background)
        }
    }

}
