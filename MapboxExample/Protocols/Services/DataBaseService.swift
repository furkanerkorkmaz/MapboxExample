//
//  DataBaseService.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 29.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation
import CoreData

protocol DataBaseService {

    var readContext: NSManagedObjectContext { get }
    
    func fetchRecords(from entityName: String?) -> [NSManagedObject]
    func clearData<E: EntityConvertible>(entity: E, completion:  @escaping TaskFinishedCompletion)
    func store<E: EntityConvertible>(entity: E, saveContext: Bool, forThread type: ContextThread)
    
}
