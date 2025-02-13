//
//  SettingSectionRO.swift
//  Setting
//
//  Created by choijunios on 2/13/25.
//

struct SettingSectionRO {
    let order: Int
    let titleText: String
    let items: [SettingSectionItemRO]
    
    init(order: Int, titleText: String, items: [SettingSectionItemRO]) {
        self.order = order
        self.titleText = titleText
        self.items = items
    }
}
