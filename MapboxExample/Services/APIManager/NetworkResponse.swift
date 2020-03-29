//
//  NetworkResponse.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 28.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation

struct NetworkResponse {
    
    let error: ApplicationError?
    let responseObject: AnyObject?

    // MARK: - Init/Deinit

    init(error: ApplicationError? = nil, responseObject: AnyObject? = nil) {
        self.error = error
        self.responseObject = responseObject
    }
}
