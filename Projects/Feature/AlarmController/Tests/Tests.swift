//
//  Tests.swift
//
//

import Testing
import Foundation

@testable import FeatureAlarmController

struct AlarmKeyGeneratorTests {
    
    @Test func createChild() {
        // Given
        let baseId = UUID().uuidString
        
        // When
        let child = AlarmKeyGenerator.createChildKey(base: baseId)
        
        // Then
        #expect(baseId != child)
        #expect(baseId == AlarmKeyGenerator.getRoot(id: child))
    }
    
    @Test func createSibiling() {
        // Given
        let baseId = UUID().uuidString
        let child = AlarmKeyGenerator.createChildKey(base: baseId)
        
        // When
        let root = AlarmKeyGenerator.getRoot(id: child)
        let sibiling = AlarmKeyGenerator.createChildKey(base: root)
        
        // Then
        #expect(root == AlarmKeyGenerator.getRoot(id: sibiling))
    }
}
