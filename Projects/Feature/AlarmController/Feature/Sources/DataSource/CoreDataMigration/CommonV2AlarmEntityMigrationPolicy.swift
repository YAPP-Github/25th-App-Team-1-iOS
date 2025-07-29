//
//  CommonV2AlarmEntityMigrationPolicy.swift
//  AlarmController
//
//  Created by choijunios on 7/29/25.
//

import CoreData

import FeatureCommonEntity

@objc
class CommonV2AlarmEntityMigrationPolicy: NSEntityMigrationPolicy {
    
    override func createDestinationInstances(
        forSource sInstance: NSManagedObject,
        in mapping: NSEntityMapping,
        manager: NSMigrationManager
    ) throws {
        try super.createDestinationInstances(forSource: sInstance, in: mapping, manager: manager)
        
        guard let destination = manager.destinationInstances(forEntityMappingName: mapping.name, sourceInstances: [sInstance]).first else { return }
        
        // 새로 추가된 관계 초기화 예시
        let context = manager.destinationContext
        let newRelatedObject = NSEntityDescription.insertNewObject(forEntityName: "Mission", into: context)
        
        let defaultMission = FeatureCommonEntity.Mission.default
        newRelatedObject.setValue(
            defaultMission.type.rawValue,
            forKey: "type"
        )
        newRelatedObject.setValue(
            Int16(defaultMission.count),
            forKey: "count"
        )
        destination.setValue(newRelatedObject, forKey: "mission")
    }
}
