//
//  Parser.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 28.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation

protocol Parser {
    associatedtype Element
    func parse(type: Element.Type, from data: Data) -> (Element?, Error?)
}
