//
//  CoreDataStack.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 05/09/2023.
//

import Foundation
import CoreData

final class CoreDataStack {

    private let persistentContainerName = "AmericanDream"

    static let shared = CoreDataStack()

    var viewContext: NSManagedObjectContext {
        return CoreDataStack.shared.persistentContainer.viewContext
    }

    private init() {}

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: persistentContainerName)
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                print("Unresolved error \(error) for \(description.description)")
            }
        }
        return container
    }()
}
