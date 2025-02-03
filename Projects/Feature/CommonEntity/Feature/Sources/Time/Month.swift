//
//  Month.swift
//  FeatureCommonEntity
//
//  Created by 손병근 on 2/1/25.
//

import Foundation

public enum Month: Int, CaseIterable {
    case january = 1, february, march, april, may, june
    case july, august, september, october, november, december

    public var toKoreanFormat: String {
        return switch self {
        case .january:
            "1월"
        case .february:
            "2월"
        case .march:
            "3월"
        case .april:
            "4월"
        case .may:
            "5월"
        case .june:
            "6월"
        case .july:
            "7월"
        case .august:
            "8월"
        case .september:
            "9월"
        case .october:
            "10월"
        case .november:
            "11월"
        case .december:
            "12월"
        }
    }
}
