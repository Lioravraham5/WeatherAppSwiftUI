//
//  PersistenceController.swift
//  WeatherAppSwiftUI
//
//  Created by Lior.Avraham on 17/02/2026.
//

import Foundation
import CoreData

// Responsible for configuring and managing the Core Data stack.
// Provides a single access point to NSPersistentContainer
final class PersistenceController {
    
    // Shared singleton instance used across the application.
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    // Private initializer to enforce singleton usage.
    // Parameter inMemory: When true, the store is created in memory instead of writing to disk. Useful for unit testing.
    private init(inMemory: Bool = false) {
        
        container = NSPersistentContainer(name: "WeatherApp")
        
        // Configure in-memory store for testing environments.
        // This prevents data from being persisted to disk.
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Load the persistent store and connect it to the container.
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error: \(error), \(error.userInfo)")
            }
        }
        
        // Automatically merge changes saved in background contexts into the main viewContext. This keeps UI in sync.
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // Merge policy defines conflict resolution behavior.
        // NSMergeByPropertyObjectTrumpMergePolicy means the in-memory object values take precedence over store values.
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    // Executes a block on a background managed object context.
    // This should be used for write operations to avoid blocking the main thread.
    // - Parameter block: A closure that receives a background context.
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        container.performBackgroundTask(block)
    }
    
    // Saves changes in the provided context if needed.
    // Parameter context: The managed object context to save.
    // Throws: Any error that occurs during save().
    // This method avoids unnecessary save operations by checking `hasChanges`.
    func save(context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
