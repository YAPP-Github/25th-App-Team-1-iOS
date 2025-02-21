//
//  Fortune.swift
//  FeatureCommonEntity
//
//  Created by ever on 2/14/25.
//

import UIKit
import FeatureResources

public struct Fortune: Codable {
    public let id: Int
    public let dailyFortuneTitle: String
    public let dailyFortuneDescription: String
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
    
    public var luckyCircleColor: UIColor {
        return R.Color.color(title: luckyColor)
    }
    
    public var unluckyCircleColor: UIColor {
        return R.Color.color(title: unluckyColor)
    }
}

public struct FortuneSaveInfo: Codable, Equatable {
    public let id: Int
    public var shouldShowCharm: Bool
    public var charmIndex: Int?
    
    public init(id: Int, shouldShowCharm: Bool, charmIndex: Int?) {
        self.id = id
        self.shouldShowCharm = shouldShowCharm
        self.charmIndex = charmIndex
    }
}
