//
//  CoreDataManager.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 12/04/22.
//

import CoreData

class CoreDataManager {
    private let container: NSPersistentContainer
    init(){
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error loading store \(description) - \(error)")
                return
            }
        }
    }
    func getViewContext() -> NSManagedObjectContext {
        return container.viewContext
    }
    func getBackgroundContext() -> NSManagedObjectContext {
        return container.newBackgroundContext()
    }
}
