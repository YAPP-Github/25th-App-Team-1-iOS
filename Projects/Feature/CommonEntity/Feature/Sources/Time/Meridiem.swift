//
//  Meridiem.swift
//  FeatureCommonEntity
//
//  Created by 손병근 on 2/1/25.
//

import Foundation

public enum Meridiem: String {
    case am = "AM"
    case pm = "PM"
    
    public var toKoreanFormat: String {
        switch self {
        case .am:
            "오전"
        case .pm:
            "오후"
        }
    }
}
