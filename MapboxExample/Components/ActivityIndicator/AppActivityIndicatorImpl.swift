//
//  AppActivityIndicatorImpl.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 28.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation
class AppActivityIndicatorImpl {
    
    static let shared: AppActivityIndicator = AppActivityIndicatorImpl()

    private var activityIndicator: ActivityIndicator?
        
}

extension AppActivityIndicatorImpl: AppActivityIndicator {
    
    var isShown: Bool {
        return self.activityIndicator != nil
    }

    func show() {
        if isShown { return }
        activityIndicator = ActivityIndicator.create()
        activityIndicator?.show()
    }
    
    func close() {
        activityIndicator?.close(completion: { [weak self] in
            self?.activityIndicator = nil
        })
    }

}
