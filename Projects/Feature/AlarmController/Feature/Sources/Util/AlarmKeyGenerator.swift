//
//  AlarmKeyGenerator.swift
//  AlarmController
//
//  Created by choijunios on 3/12/25.
//

import Foundation

enum AlarmKeyGenerator {
    private static let separator = ">>"
    
    static func createChildKey(base: String, child: String = UUID().uuidString) -> String {
        [base, child].joined(separator: separator)
    }
    
    static func getRoot(id: String) -> String {
        if isRoot(id: id) { return id }
        return String(id.split(separator: separator)[0])
    }
    
    static func isRoot(id: String) -> Bool {
        !id.contains(separator)
    }
}
