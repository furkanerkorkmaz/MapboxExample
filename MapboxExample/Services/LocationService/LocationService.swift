//
//  LocationService.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 28.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationService: NSObject {

    private lazy var locationManager: CLLocationManager! = { [unowned self] in
        let manager = CLLocationManager()
            manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            manager.distanceFilter = 100
            manager.delegate = self
        return manager
    }()
    
    private let geocoder: CLGeocoder = CLGeocoder()
    internal var isLocationEnabled = false
    private var userLocationCompletion: UserLocationCompletion?

    // MARK: - Init/Deinit

    override init() {
        super.init()
        locationManager.requestAlwaysAuthorization()
    }
}

// MARK: - LocationManager
extension LocationService: LocationManager {
    
    var locationEnabled: Bool {
        let status = CLLocationManager.authorizationStatus()
        return (status == .authorizedWhenInUse || status == .authorizedAlways)
    }
    
    func fetcthUserLocation(completion: @escaping UserLocationCompletion) {
        userLocationCompletion = completion
        if CLLocationManager.locationServicesEnabled() {
            let status = CLLocationManager.authorizationStatus()
            if status == .denied {
                finishWithError(ApplicationError.locationDisabled)
            } else if status == .notDetermined {
                locationManager.requestAlwaysAuthorization()
            } else {
                locationManager.requestLocation()
            }
        } else {
            finishWithError(ApplicationError.locationDisabled)
        }
    }
    
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if userLocationCompletion != nil {
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                isLocationEnabled = true
                locationManager.requestLocation()
            case .denied, .restricted:
                isLocationEnabled = false
                finishWithError(ApplicationError.locationDisabled)
            default:
                break
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        finishWithError(ApplicationError.locationCantBeFetched)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        handle(currentLocation: locations.last)
    }

}

// MARK: - Private functions
private extension LocationService {
    
    private func handle(currentLocation: CLLocation?) {
        if let location = currentLocation {
            userLocationCompletion?(location, nil)
            userLocationCompletion = nil
        } else {
            finishWithError(ApplicationError.locationCantBeFetched)
        }
    }
    
    func finishWithError(_ err: ApplicationError?) {
        userLocationCompletion?(nil, err)
        userLocationCompletion = nil
    }

}
