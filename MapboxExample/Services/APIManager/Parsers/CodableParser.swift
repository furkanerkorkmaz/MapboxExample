//
//  CodableParser.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 28.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation

final class CodableParser<T: Codable> {
    private let decoder: JSONDecoder = JSONDecoder()
}

// MARK: - Parser
extension CodableParser: Parser {

    typealias Element = T

    func parse(type: T.Type, from data: Data) -> (T?, Error?) {
        do {
            return (try decoder.decode(type, from: data), nil)
        } catch {
            return (nil, error)
        }
    }

}
