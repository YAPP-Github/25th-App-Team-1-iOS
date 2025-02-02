//
//  SoundOption.swift
//  FeatureCommonEntity
//
//  Created by ever on 2/2/25.
//

import Foundation

public struct SoundOption {
    public var isVibrationOn: Bool
    public var isSoundOn: Bool
    public var volume: Float
    public var selectedSound: String
    
    public init(isVibrationOn: Bool, isSoundOn: Bool, volume: Float, selectedSound: String) {
        self.isVibrationOn = isVibrationOn
        self.isSoundOn = isSoundOn
        self.volume = volume
        self.selectedSound = selectedSound
    }
}
