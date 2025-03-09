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
    func performSyncTask<T>(closure: @escaping (NSManagedObjectContext) -> Result<T, any Error>) -> Result<T, any Error>
    func performAsyncTask<T>(type: ContextType, closure: @escaping (NSManagedObjectContext, (Result<T, Error>) -> Void) -> Void) -> Single<Result<T, Error>>
}
