//
//  AudioPlayerManager.swift
//  FeatureAlarmCommon
//
//  Created by ever on 2/26/25.
//

import AVFoundation

public final class AudioPlayerManager: NSObject, AVAudioPlayerDelegate {
    public static let shared = AudioPlayerManager()
    private var audioPlayer: AVAudioPlayer?
    
    private override init() {
        super.init()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(
                .playback,
                mode: .default,
                options: [] // 기본 스피커에서 재생되어야함.(이어폰 아닌)
            )
        } catch {
            print(String(format: "playInBackground error: %@",
                         error.localizedDescription))
        }
    }
    
    // 음원 재생
    public func activateSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true)
        } catch {
            print("audioSession 활성화 실패: \(error.localizedDescription)")
        }
    }
    
    public func playAlarmSound(with url: URL, volume: Float, loopCount: Int = -1) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.numberOfLoops = loopCount // 반복 횟수 설정 (-1은 무한 반복)
            audioPlayer?.volume = volume
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("AVAudioPlayer 초기화 실패: \(error.localizedDescription)")
        }
    }
    
    public func stopPlayingSound() {
        audioPlayer?.stop()
    }
}
