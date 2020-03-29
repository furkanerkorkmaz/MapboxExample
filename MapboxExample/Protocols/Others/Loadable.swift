//
//  Loadable.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 28.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import UIKit

protocol Loadable {
    func startLoading()
    func stopLoading()
}

extension Loadable where Self: UIViewController {

    func startLoading() {
        view.showActivityIndicator()
    }

    func stopLoading() {
        view.removeActivityIndicator()
    }

}
