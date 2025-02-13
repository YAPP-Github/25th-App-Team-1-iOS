//
//  UserInfoCardRO.swift
//  Setting
//
//  Created by choijunios on 2/13/25.
//

import FeatureCommonEntity

struct UserInfoCardRO {
    let nameText: String
    let genderText: String
    let lunarText: String
    let birthDateText: String
    let bornTimeText: String?
    
    init(nameText: String, genderText: String, lunarText: String, birthDateText: String, bornTimeText: String?) {
        self.nameText = nameText
        self.genderText = genderText
        self.lunarText = lunarText
        self.birthDateText = birthDateText
        self.bornTimeText = bornTimeText
    }
}
