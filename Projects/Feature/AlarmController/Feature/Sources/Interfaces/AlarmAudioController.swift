//
//  AlarmAudioController.swift
//  FeatureAlarmController
//
//  Created by choijunios on 3/8/25.
//

import Foundation

public protocol AlarmAudioController {
    func play(id: String, audioURL: URL, volume: Float)
    func stopAndRemove(matchingType: IdMatchingType, id: String)
}
