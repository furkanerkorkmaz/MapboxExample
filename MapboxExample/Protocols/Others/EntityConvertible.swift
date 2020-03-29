//
//  EntityConvertible.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 29.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation
import CoreData

protocol EntityConvertible {
    
    associatedtype Entity: NSManagedObject
    
    static var entityName: String { get }
    
    var entityName: String? { get }
    
    init(entity: Entity)
    
    func convertToEntity(for context: NSManagedObjectContext) throws -> Entity
    
}
