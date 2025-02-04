//
//  AlarmManager.swift
//  FeatureAlarm
//
//  Created by ever on 2/1/25.
//

import AVFoundation

final class AlarmManager: NSObject, AVAudioPlayerDelegate {
    static let shared = AlarmManager()
    private var audioPlayer: AVAudioPlayer?
    
    private override init() {
        super.init()
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                policy: .longFormAudio,
                options: [.defaultToSpeaker] // 기본 스피커에서 재생되어야함.(이어폰 아닌)
            )
        } catch {
            print(String(format: "playInBackground error: %@",
                         error.localizedDescription))
        }
    }
    
    // 음원 재생
    func playAlarmSound(with url: URL, loopCount: Int = -1) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.numberOfLoops = loopCount // 반복 횟수 설정 (-1은 무한 반복)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("AVAudioPlayer 초기화 실패: \(error.localizedDescription)")
        }
    }
    
    func stopPlayingSound() {
        audioPlayer?.stop()
    }
}
