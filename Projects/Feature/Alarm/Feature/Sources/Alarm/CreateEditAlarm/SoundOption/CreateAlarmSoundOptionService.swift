//
//  CreateEditAlarmSoundOptionService.swift
//  FeatureAlarm
//
//  Created by ever on 2/4/25.
//

import FeatureCommonDependencies
import FeatureResources
import FeatureAlarmCommon

protocol CreateEditAlarmSoundOptionServiceable {
    func playSound(with option: SoundOption)
    func stopSound()
}

struct CreateEditAlarmSoundOptionService: CreateEditAlarmSoundOptionServiceable {
    func playSound(with option: SoundOption) {
        guard let sound = R.AlarmSound.allCases.first(where: { $0.title == option.selectedSound })?.alarm else { return }
        VolumeManager.setVolume(option.volume) // 설정한 볼륨값 0.0~1.0으로 설정
        AudioPlayerManager.shared.playAlarmSound(with: sound, volume: option.volume, loopCount: 1)
    }
    
    func stopSound() {
        AudioPlayerManager.shared.stopPlayingSound()
    }
}
