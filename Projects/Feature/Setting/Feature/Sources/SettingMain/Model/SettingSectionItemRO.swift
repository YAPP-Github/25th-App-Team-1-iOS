//
//  SettingSectionItemRO.swift
//  Setting
//
//  Created by choijunios on 2/13/25.
//

struct SettingSectionItemRO: Identifiable {
    let id: Int
    let title: String
    let task: (() -> Void)?
}
