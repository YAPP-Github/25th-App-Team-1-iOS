//
//  Meridiem.swift
//  Main
//
//  Created by choijunios on 1/31/25.
//

enum Meridiem {
    case am, pm
    var korText: String {
        switch self {
        case .am:
            "오전"
        case .pm:
            "오후"
        }
    }
}
