//
//  MissionItemRenderObject.swift
//  ConfigureMissionForAlarm
//
//  Created by choijunios on 7/22/25.
//

import UIKit

import FeatureResources

enum MissionItemRenderObject {
    case shake
    case tap
    
    static var defaultList: [Self] {
        [.shake, .tap]
    }
    
    var title: String {
        switch self {
        case .shake:
            "흔들기"
        case .tap:
            "터치하기"
        }
    }
    
    var iconImage: UIImage {
        switch self {
        case .shake:
            FeatureResourcesAsset.shakeMissionConfigItem.image
        case .tap:
            FeatureResourcesAsset.tapMissionConfigItem.image
        }
    }
    
    var guideLottiePath: String {
        switch self {
        case .shake:
            return Bundle.resources.path(forResource: "mission_shake_condition_setting", ofType: "json")!
        case .tap:
            return Bundle.resources.path(forResource: "mission_tap_condition_setting", ofType: "json")!
        }
    }
    
    var conditionItems: [MissionCondtionItem] {
        [
            MissionCondtionItem(title: "5회", value: 5),
            MissionCondtionItem(title: "10회", value: 10),
            MissionCondtionItem(title: "15회", value: 15),
            MissionCondtionItem(title: "20회", value: 20),
            MissionCondtionItem(title: "25회", value: 25),
        ]
    }
}
