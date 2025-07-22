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
}
