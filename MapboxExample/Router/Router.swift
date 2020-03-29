//
//  Router.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 28.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import UIKit

final class Router {

    static let shared: ApplicationRouter = Router(window: UIApplication.shared.delegate!.window!!) // swiftlint:disable:this force_unwrapping
    private let window: UIWindow

    private lazy var rootNavController: UINavigationController = {
        let result: UINavigationController = UINavigationController()
        result.isNavigationBarHidden = true
        return result
    }()

    // MARK: - Init
    private init(window aWindow: UIWindow) {
        window = aWindow
        window.rootViewController = rootNavController
    }

    // MARK: - Private
    private func switchTo(vc aVc: UIViewController) {
        let snapShot: UIView? = window.snapshotView(afterScreenUpdates: false)

        if let snapShot: UIView = snapShot {
            self.window.addSubview(snapShot)
        }

        window.rootViewController?.dismiss(animated: false, completion: nil)
        rootNavController.setViewControllers([aVc], animated: false)

        if let snapShot: UIView = snapShot {
            self.window.bringSubviewToFront(snapShot)
            UIView.animate(withDuration: 0.3, animations: {
                snapShot.layer.opacity = 0
            }, completion: { _ in
                DispatchQueue.main.async {
                    snapShot.removeFromSuperview()
                }
            })
        }
    }

    private func dismiss(vc aVc: UIViewController, completion aCallBack: @escaping (() -> Swift.Void)) {
        if let viewController: UIViewController = aVc.presentedViewController {
            self.dismiss(vc: viewController, completion: {
                aVc.dismiss(animated: true, completion: {
                    aCallBack()
                })
            })
        } else {
            aCallBack()
        }
    }

}

// MARK: - ApplicationRouter
extension Router: ApplicationRouter {

    func configured() { }

    func openMap() {
        let model = MapModel(locationManager: LocationService())
        switchTo(vc: MapViewController(with: model))
    }

}
