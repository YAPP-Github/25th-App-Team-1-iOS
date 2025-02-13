//
//  Fortune.swift
//  FeatureCommonEntity
//
//  Created by ever on 2/14/25.
//

import Foundation

public struct Fortune: Codable {
    public let id: Int
    public let dailyFortune: String
    public let avgFortuneScore: Int
    public let studyCareerFortune: FortuneDetail
    public let wealthFortune: FortuneDetail
    public let healthFortune: FortuneDetail
    public let loveFortune: FortuneDetail
    public let luckyOutfitTop: String
    public let luckyOutfitBottom: String
    public let luckyOutfitShoes: String
    public let luckyOutfitAccessory: String
    public let unluckyColor: String
    public let luckyColor: String
    public let luckyFood: String
}
