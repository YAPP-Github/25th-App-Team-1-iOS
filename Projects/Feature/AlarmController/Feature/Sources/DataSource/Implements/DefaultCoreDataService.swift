//
//  DefaultCoreDataService.swift
//  FeatureAlarmController
//
//  Created by choijunios on 2/4/25.
//

import CoreData

import RxSwift

public final class DefaultCoreDataService: CoreDataService {
    
    // Container
    private var container: NSPersistentContainer!
    
    
    // Context
    private var mainContext: NSManagedObjectContext {
        container.viewContext
    }
    private(set) lazy var backgroundContext: NSManagedObjectContext = {
        container.newBackgroundContext()
    }()
    
    public init() {
        prepareContainer()
    }
    
    private func getContext(_ type: ContextType) -> NSManagedObjectContext {
        switch type {
        case .background:
            backgroundContext
        case .main:
            mainContext
        }
    }
}


// MARK: CoreDataService
public extension DefaultCoreDataService {
    func performSyncTask<T, F>(closure: @escaping (NSManagedObjectContext) -> Result<T, F>) -> Result<T, F> where F: Error {
        let context = backgroundContext
        var result: Result<T, F>!
        context.performAndWait {
            result = closure(context)
        }
        return result!
    }
    
    func performAsyncTask<T, F>(type: ContextType, closure: @escaping (NSManagedObjectContext, (Result<T, F>) -> Void) -> Void) -> Single<Result<T, F>> where F: Error {
        let context = getContext(type)
        return Single.create { [weak context] promise in
            guard let context else { return Disposables.create() }
            context.perform {
                closure(context) { result in
                    switch result {
                    case .success(let value):
                        promise(.success(.success(value)))
                    case .failure(let error):
                        promise(.success(.failure(error)))
                    }
                }
            }
            return Disposables.create()
        }
    }
}


// MARK: Prepare container
private extension DefaultCoreDataService {
    
    func prepareContainer() {
        let bundle = Bundle(for: Self.self)
        let modelURL = bundle.url(forResource: "Common", withExtension: ".momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        let container = NSPersistentContainer(name: "DefaultStorage", managedObjectModel: model)
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dataBasePath = storeURL.appendingPathComponent("DefaultStorage.sqlite")
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: dataBasePath)]
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
            print("✅ NSPersistentContainer loaded")
        }
        self.container = container
    }
}
