//
//  DefaultVibrationManager.swift
//  FeatureAlarmController
//
//  Created by choijunios on 3/9/25.
//

import AVFoundation

public class DefaultVibrationManager: VibrationManager {
    
    public init() { }
    
    public func vibarate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}

