//
//  CoreDataTest.swift
//  ArtIntituteChicagoTests
//
//  Created by Natalia Goyes on 15/05/22.
//

import XCTest
@testable import ArtIntituteChicago
import CoreData

class CoreDataTest {
        private let container: NSPersistentContainer
        init(){
            container = NSPersistentContainer(name: "Model")
            let description = container.persistentStoreDescriptions.first
            description?.type = NSInMemoryStoreType
            
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
}
