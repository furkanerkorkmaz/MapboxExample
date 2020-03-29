//
//  UIView+Help.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 28.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import UIKit

protocol UIViewLoading { }

extension UIViewLoading where Self: UIView {

    static func loadFromNib(nibNameOrNil: String? = nil) -> Self {
        let result: Self = Bundle.main.loadNibNamed(String(describing: self),
                                                    owner: self,
                                                    options: nil)?.first as! Self // swiftlint:disable:this force_cast
        return result
    }
}

extension UIView: UIViewLoading { }
