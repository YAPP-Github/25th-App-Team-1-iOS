//
//  CoreDataService.swift
//  FeatureAlarmController
//
//  Created by choijunios on 2/4/25.
//

import CoreData

import RxSwift

public enum ContextType {
    case background
    case main
}

public protocol CoreDataService: AnyObject {
    func performSyncTask<T, F>(closure: @escaping (NSManagedObjectContext) -> Result<T, F>) -> Result<T, F> where F: Error
    func performAsyncTask<T, F>(type: ContextType, closure: @escaping (NSManagedObjectContext, (Result<T, F>) -> Void) -> Void) -> Single<Result<T, F>> where F: Error
}
