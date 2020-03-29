//
//  UIView+Activity.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 28.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import UIKit

extension UIView {

    func showActivityIndicator() {
        AppActivityIndicatorImpl.shared.show()
    }

    func removeActivityIndicator() {
        AppActivityIndicatorImpl.shared.close()
    }

}
