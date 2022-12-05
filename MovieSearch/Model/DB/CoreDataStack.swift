//
//  CoreDataStack.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import Foundation
import CoreData

final class CoreDataStack {

    /// shared instanace
    fileprivate static let shared = CoreDataStack(modelName: "DataModel") { print($0.localizedDescription) }

    /// view context
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    /// background context
    lazy var backgroundContext: NSManagedObjectContext = {
        self.container.newBackgroundContext()
    }()

    /// can be used to log db errors e.g. to crashlytics
    let errorCallback: (Error) -> Void

    /// save without wait
    func write(_ block: @escaping (NSManagedObjectContext) throws -> Void) {
        let context = backgroundContext
        context.perform { [weak self] in
            do {
                try block(context)
                if context.hasChanges {
                    try context.save()
                }
            }
            catch {
                self?.errorCallback(error)
            }
        }
    }

    // MARK: - private

    /// persistent container
    private let container: NSPersistentContainer

    /// default initializer
    private init(modelName: String, errorCallback: @escaping (Error) -> Void) {
        self.errorCallback = errorCallback
        container = NSPersistentContainer(name: modelName)
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error {
                fatalError("Failed setting up database \(error)")
            }
        })
    }
}

protocol InjectDatabase {
    var database: CoreDataStack { get }
}

extension InjectDatabase {
    var database: CoreDataStack {
        .shared
    }
}

