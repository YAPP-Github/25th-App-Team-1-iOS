//
//  FortunePageViewEvent.swift
//  Fortune
//
//  Created by choijunios on 3/17/25.
//

enum FortunePageViewEvent: Int {
    case letter=1
    case studyMoney=2
    case healthLove=3
    case coordination=4
    case reference=5
    case complete=6
    case charm
    
    var eventName: String {
        switch self {
        case .letter:
            "fortune_view_today"
        case .studyMoney:
            "fortune_view_category1"
        case .healthLove:
            "fortune_view_category2"
        case .coordination:
            "fortune_view_style"
        case .reference:
            "fortune_view_refer"
        case .complete:
            "fortune_view_end"
        case .charm:
            "talisman_view"
        }
    }
    
    var pageNumber: Int { self.rawValue }
}
