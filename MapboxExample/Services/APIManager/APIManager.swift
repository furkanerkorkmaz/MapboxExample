//
//  APIManager.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 28.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    func parse<T: Codable>(type: T.Type, from data: Data) -> (T?, Error?) {
        do {
            return try (JSONDecoder().decode(type, from: data), nil)
        } catch {
            return (nil, error)
        }
    }
}

// MARK: - NetworkDataProvider

extension APIManager: NetworkDataProvider {
    
    func request<T>(_ request: NetworkRequest, parser: T, completionHandler: @escaping (NetworkResponse) -> Void) where T: Parser {
        Alamofire.request(request.path,
                          method: request.method,
                          parameters: request.params).response
            { response in
            guard let data: Data = response.data, response.error == nil else {
                completionHandler(NetworkResponse(error: ApplicationError.serverError(response.error?.localizedDescription)))
                return
            }
                let result: (object: T.Element?, error: Error?) = parser.parse(type: T.Element.self, from: data)
                if result.error != nil {
                    completionHandler(NetworkResponse(error: ApplicationError.invalidJSON))
                } else {
                    completionHandler(NetworkResponse(responseObject: result.object as AnyObject))
                }
        }
    }
    
}
