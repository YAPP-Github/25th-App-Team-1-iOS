//
//  File.swift
//  AlarmController
//
//  Created by choijunios on 3/9/25.
//

import Foundation

import FeatureResources
import FeatureCommonEntity

extension Alarm {
    var selectedSoundUrl: URL? {
        R.AlarmSound.allCases.first(where: { $0.title == soundOption.selectedSound })?.alarm
    }
}
