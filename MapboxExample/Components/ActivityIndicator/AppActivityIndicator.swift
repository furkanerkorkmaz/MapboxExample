//
//  AppActivityIndicator.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 28.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation

protocol AppActivityIndicator {
    
    var isShown: Bool { get }

    func show()
    func close()
    
}
