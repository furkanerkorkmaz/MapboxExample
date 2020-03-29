//
//  NetworkDataProvider.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 28.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation

protocol NetworkDataProvider {
    
    func request<T>(_ request: NetworkRequest, parser: T, completionHandler: @escaping (NetworkResponse) -> Void) where T: Parser
    
}
