//
//  VolumeManager.swift
//  FeatureAlarm
//
//  Created by ever on 2/1/25.
//

import MediaPlayer

struct VolumeManager {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
}
