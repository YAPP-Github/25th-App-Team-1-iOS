//
//  VolumeManager.swift
//  FeatureCommonDependencies
//
//  Created by ever on 2/8/25.
//

import MediaPlayer

public struct VolumeManager {
    public static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
}
