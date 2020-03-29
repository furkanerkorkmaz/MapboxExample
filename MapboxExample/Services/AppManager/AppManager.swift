//
//  AppManager.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 28.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation
final class AppManager {

    static let shared: AppManagerProtocol = AppManager()

    // MARK: - Init/Deinit
    private init() {

    }

}

// MARK: - AppManagerProtocol
extension AppManager: AppManagerProtocol {

    func showStartScreen() {
        Router.shared.openMap()
    }

}
