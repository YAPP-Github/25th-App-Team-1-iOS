//
//  Days.swift
//  Main
//
//  Created by choijunios on 1/31/25.
//

enum Days: Int {
    case mon=0
    case tue=1
    case wed=2
    case thu=3
    case fri=4
    case sat=5
    case sun=6
    
    var korOneWord: String {
        switch self {
        case .mon:
            "월"
        case .tue:
            "화"
        case .wed:
            "수"
        case .thu:
            "목"
        case .fri:
            "금"
        case .sat:
            "토"
        case .sun:
            "일"
        }
    }
}

extension Array where Element == Days {
    var isRestOnHoliday: Bool {
        !(self.contains(where: { $0 == .sat }) || self.contains(where: { $0 == .sun }))
    }
}
