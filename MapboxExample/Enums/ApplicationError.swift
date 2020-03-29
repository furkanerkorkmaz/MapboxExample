//
//  ApplicationError.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 28.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation

protocol ErrorStringConvertible {
    var errorDescription: String { get }
}

protocol ApplicationBaseError: ErrorStringConvertible {}

enum ApplicationError: ApplicationBaseError  {
    
    case invalidJSON
    case locationDisabled
    case locationCantBeFetched
    case serverError(String?)
    case maxCoordinatesNumberReachedError

    var errorDescription: String {
        switch self {
        case .invalidJSON:
            return L10n.invalidJSONError
        case .locationDisabled:
            return L10n.locationDisabledError
        case .locationCantBeFetched:
            return L10n.locationCantBeFetched
        case .serverError(let msg):
            return msg ?? "Invalid request"
        case .maxCoordinatesNumberReachedError:
            return L10n.maxCoordinatesNumberReachedError
        }
    }
    
}
