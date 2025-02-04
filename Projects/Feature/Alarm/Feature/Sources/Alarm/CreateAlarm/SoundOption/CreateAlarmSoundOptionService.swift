//
//  CreateAlarmSoundOptionService.swift
//  FeatureAlarm
//
//  Created by ever on 2/4/25.
//

import FeatureCommonDependencies
import FeatureResources

protocol CreateAlarmSoundOptionServiceable {
    func playSound(with option: SoundOption)
    func stopSound()
}

struct CreateAlarmSoundOptionService: CreateAlarmSoundOptionServiceable {
    func playSound(with option: SoundOption) {
        guard let sound = R.AlarmSound.allCases.first(where: { $0.title == option.selectedSound })?.alarm else { return }
        VolumeManager.setVolume(option.volume) // 설정한 볼륨값 0.0~1.0으로 설정
        AlarmManager.shared.playAlarmSound(with: sound, loopCount: 1)
    }
    
    func stopSound() {
        AlarmManager.shared.stopPlayingSound()
    }
}
