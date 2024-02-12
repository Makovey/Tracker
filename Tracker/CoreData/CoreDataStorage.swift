//
//  CoreDataStorage.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 12.02.2024.
//

import CoreData
import Foundation

protocol IPersistenceStorage {
    func save()
}

final class CoreDataStorage: IPersistenceStorage {
    private enum Constant {
        static let modelName = "TrackerModel"
    }

    // MARK: - Properties
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constant.modelName)
        container.loadPersistentStores { description, error in
            if let error = error as? NSError {
                fatalError("Can't load persistence stores cause: \(error)")
            }
        }
        
        return container
    }()
    
    // MARK: - Public
    
    func save() {
        print(#function)
    }

    // MARK: - Private
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
