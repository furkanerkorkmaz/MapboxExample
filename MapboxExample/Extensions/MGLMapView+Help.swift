//
//  MGLMapView+Help.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 28.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Mapbox

extension MGLMapView {
    
    func addAnnotation(locationCoordinate: CLLocationCoordinate2D) {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.subtitle = "\(locationCoordinate.latitude), \(locationCoordinate.longitude)"
        self.addAnnotation(annotation)
    }
    
    func addPolyline(routeCoordinates: [CLLocationCoordinate2D]) {
        let polyline = MGLPolyline(coordinates: routeCoordinates, count: UInt(routeCoordinates.count))
        self.addAnnotation(polyline)
    }
    
    func clearMap() {
        guard let annotations = self.annotations else {
            return
        }
        self.removeAnnotations(annotations)
    }
}
