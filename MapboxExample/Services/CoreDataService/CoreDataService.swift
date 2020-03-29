//
//  CoreDataService.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 29.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import Foundation
import CoreData

enum ContextThread {
    case main
    case background
}

final class CoreDataService {
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container: NSPersistentContainer = NSPersistentContainer(name: "MapboxExample")
            container.viewContext.automaticallyMergesChangesFromParent = true

        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error: NSError = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    fileprivate var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    fileprivate lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        return context
    }()
    
}

// MARK: - DataBaseService
extension CoreDataService: DataBaseService {

    var readContext: NSManagedObjectContext {
        return mainContext
    }
    
    func fetchRecords(from entityName: String?) -> [NSManagedObject] {
        guard let entityName = entityName else { return [] }
        let managedContext = self.persistentContainer.viewContext
        var result = [NSManagedObject]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        do {
            result = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return result
    }
    
    func clearData<E: EntityConvertible>(entity: E, completion:  @escaping TaskFinishedCompletion) {
        self.persistentContainer.performBackgroundTask { [weak self] (context) in
            guard let `self` = self,
                let entityName = entity.entityName else { return }
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                do {
                    let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                    _ = objects.map{$0.map{context.delete($0)}}
                    do {
                        try context.save()
                        self.persistentContainer.viewContext.perform {
                            completion(true)
                        }
                    } catch {
                        completion(false)
                    }
                } catch _ {
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - Store Entity
    func store<E: EntityConvertible>(entity: E, saveContext: Bool, forThread type: ContextThread) {
        switch type {
        case .main:
            performStoreInMain(entity: entity, in: persistentContainer, saveContext: saveContext)
        case .background:
            performStoreInBackground(entity: entity, in: persistentContainer, saveContext: saveContext)
        }
    }
    
    private func performStoreInMain<E: EntityConvertible>(entity: E, in container: NSPersistentContainer, saveContext: Bool = false) {
        container.viewContext.perform {
            self.create(entity: entity, for: container.viewContext, andSave: saveContext)
        }
    }
    
    private func performStoreInBackground<E: EntityConvertible>(entity: E, in container: NSPersistentContainer, saveContext: Bool = false) {
        container.performBackgroundTask { [weak self] context in
            self?.create(entity: entity, for: context, andSave: saveContext)
        }
    }
    
    private func create<E: EntityConvertible>(entity: E, for context: NSManagedObjectContext, andSave saveContext: Bool) {
        do {
            _ = try entity.convertToEntity(for: context)
            if saveContext {
                self.save(context: context)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func save(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

}
