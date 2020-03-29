//
//  MapViewController.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 28.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController {

    private lazy var mapView: MGLMapView = { [unowned self] in
        let mapView = MGLMapView(frame: view.bounds)
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            mapView.logoView.isHidden = true
            mapView.isPitchEnabled = false // Lock map perspective
            // Enable heading tracking mode so that the arrow will appear.
            mapView.userTrackingMode = .follow
            mapView.showsUserLocation = true
            // Enable the permanent heading indicator, which will appear when the tracking mode is not `.followWithHeading`.
            mapView.showsUserHeadingIndicator = true
        return mapView
    }()
    
    private lazy var saveBarButton: UIBarButtonItem = {
        let item: UIBarButtonItem = UIConfigurator.makeSaveBarButton()
        (item.customView as? UIButton)?.addTarget(self, action: #selector(saveRouteAction), for: .touchUpInside)
        return item
    }()

    private lazy var removeBarButton: UIBarButtonItem = {
        let item: UIBarButtonItem = UIConfigurator.makeRemoveBarButton()
        (item.customView as? UIButton)?.addTarget(self, action: #selector(removeRouteAction), for: .touchUpInside)
        return item
    }()

    private lazy var undoBarButton: UIBarButtonItem = {
        let item: UIBarButtonItem = UIConfigurator.makeUndoBarButton()
        (item.customView as? UIButton)?.addTarget(self, action: #selector(undoAction), for: .touchUpInside)
        return item
    }()
    
    private var isNavigationRightButtonsHidden: Bool = true {
        didSet {
            if isNavigationRightButtonsHidden != oldValue {
                let button: UIBarButtonItem? = isNavigationRightButtonsHidden ? nil : saveBarButton
                navigationItem.setRightBarButton(button, animated: true)
            }
        }
    }
    
    private var isNavigationLeftButtonsHidden: Bool = true {
        didSet {
            if isNavigationLeftButtonsHidden != oldValue {
                let buttons: [UIBarButtonItem]? = isNavigationLeftButtonsHidden ? nil : [undoBarButton, removeBarButton]
                navigationItem.setLeftBarButtonItems(buttons, animated: true)
            }
        }
    }
    
    private var model: MapModel!
    private var routeAnimationTimer: Timer?
    private var polylineIndex = 1

    // MARK: - Class functions
    init(with model: MapModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchStoredRoute()
        self.prepareNavBar()
        self.startAnimatePolyline()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopAnimatePolyline()
    }
    
}

// MARK: - Setup functions
private extension MapViewController {
    
    func prepareNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func prepareUI() {
        prepareMapView()
    }

    func prepareMapView() {
        view.addSubview(mapView)
        addLongPressGestureRecognizer()
    }
    
    func addLongPressGestureRecognizer() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longTapOnMap(_:)))
        longPress.minimumPressDuration = 2
        longPress.allowableMovement = CGFloat.greatestFiniteMagnitude
        mapView.addGestureRecognizer(longPress)
    }
}

// MARK: - Actions
private extension MapViewController {

    @objc
    func longTapOnMap(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            let touchLocation: CGPoint = sender.location(in: mapView)
            let locationCoordinate: CLLocationCoordinate2D = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            addAnnotation(locationCoordinate: locationCoordinate)
        default:
            break
        }
    }
    
    @objc
    func saveRouteAction() {
        model.saveRoute()
    }
    
    @objc
    func removeRouteAction(){
        model.clearRouteCoordinates { [weak self] (_) in
            self?.clearMapAndAddNewAnnotations()
        }
    }
    
    @objc
    func undoAction() {
        startLoading()
        model.removeLastCoordinateAndFetchNewRoute { [weak self] (_, error) in
            self?.stopLoading()
            if let error = error {
                self?.showError(error: error)
                return
            }
            self?.clearMapAndAddNewAnnotations()
        }
    }
    
    func addAnnotation(locationCoordinate: CLLocationCoordinate2D) {
        model.append(coordinate: locationCoordinate) { [weak self] (error) in
            guard let error = error else {
                self?.addNewAnnotation(locationCoordinate: locationCoordinate)
                return
            }
            self?.showError(error: error)
        }
    }
    
    func addNewAnnotation(locationCoordinate: CLLocationCoordinate2D) {
        clearMapAndAddNewAnnotations()
        if model.selectedRouteCoordinates.count > 1 {
            fetchRoute()
        }
    }
    
    func fetchStoredRoute() {
        model.fetchStoredRoute { [weak self] (mapboxDirection, error) in
            self?.clearMapAndAddNewAnnotations()
        }
    }

    func fetchRoute() {
        startLoading()
        model.fetchRoute { [weak self] (mapboxDirection, error) in
            if let error = error {
                self?.stopLoading()
                self?.showError(error: error)
                return
            }
            self?.clearMapAndAddNewAnnotations()
            self?.stopLoading()
        }
    }
    
    func showError(error: ApplicationError) {
        self.showAlert(with: L10n.errorAlertTitle, message: error.errorDescription, doneButtonTitle: L10n.continueButtonTitle)
    }
    
}

// MARK: - Map functions
private extension MapViewController {
    
    func stopAnimatePolyline() {
        routeAnimationTimer?.invalidate()
        routeAnimationTimer = nil
    }
    
    func startAnimatePolyline() {
        polylineIndex = 1
        routeAnimationTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
     
    @objc
    func tick() {
        guard let currentRouteCoordinates = model.currentRouteCoordinates else {
            stopAnimatePolyline()
            return
        }
        if polylineIndex > currentRouteCoordinates.count {
            stopAnimatePolyline()
            return
        }
        let coordinates = Array(currentRouteCoordinates[0..<polylineIndex])
        mapView.addPolyline(routeCoordinates: coordinates)
        polylineIndex += 1
    }
    
    func clearMapAndAddNewAnnotations() {
        clearMap()
        addAnnotations()
        addPolyline()
    }
    
    func addAnnotations() {
        isNavigationLeftButtonsHidden = model.selectedRouteCoordinates.isEmpty
        model.selectedRouteCoordinates.forEach({ mapView.addAnnotation(locationCoordinate: $0 )})
    }
    
    func addPolyline() {
        let isRouteEmpty = model.currentRouteCoordinates?.isEmpty ?? true
        isRouteEmpty ? stopAnimatePolyline() : startAnimatePolyline()
        isNavigationRightButtonsHidden = isRouteEmpty
    }
    
    func clearMap() {
        mapView.clearMap()
    }

}

// MARK: - Loadable
extension MapViewController: Loadable {}

// MARK: - SystemAlert
extension MapViewController: SystemAlert {}
