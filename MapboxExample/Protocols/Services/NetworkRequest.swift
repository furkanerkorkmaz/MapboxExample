//
//  NetworkRequest.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 28.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkRequest {
    var params: [String: Any] { get }
    var path: String { get }
    var method: HTTPMethod { get }
}

extension NetworkRequest {
    var params: [String: Any] {
        return [:]
    }

    var method: HTTPMethod {
        return .get
    }
}
