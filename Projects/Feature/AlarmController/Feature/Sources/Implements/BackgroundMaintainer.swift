//
//  BackgroundMaintainer.swift
//  AlarmController
//
//  Created by choijunios on 3/9/25.
//

import UIKit
import AVFoundation

public class BackgroundMaintainer {
    // State
    private var silentAudioPlayer: AVAudioPlayer?
    
    // Singleton
    public static let shared = BackgroundMaintainer()
    
    private init() { }
    
    public func activate() {
        setupSilentAudio()
        setupNotification()
    }
}


// MARK: Silent audio
private extension BackgroundMaintainer {
    func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
        } catch {
            debugPrint("\(Self.self), 오디오 세션 설정 실패: \(error.localizedDescription)")
        }
    }
    
    func setupSilentAudio() {
        guard let url = Bundle.module.url(forResource: "silent_30s", withExtension: "wav") else {
            debugPrint("\(Self.self), 오디오 파일을 찾을 수 없습니다.")
            return
        }
        do {
            silentAudioPlayer = try AVAudioPlayer(contentsOf: url)
            silentAudioPlayer?.numberOfLoops = -1
        } catch {
            debugPrint("\(Self.self), 오디오 파일을 재생할 수 없음")
        }
    }
    
    func playSilentAudio() {
        guard let silentAudioPlayer, silentAudioPlayer.isPlaying == false else { return }
        setupAudioSession()
        silentAudioPlayer.prepareToPlay()
        silentAudioPlayer.play()
    }
}


// MARK: Life cycle notification
private extension BackgroundMaintainer {
    func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onNotification(_:)),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    @objc
    func onNotification(_ notification: Notification) {
        if notification.name == UIApplication.didEnterBackgroundNotification {
            playSilentAudio()
        }
    }
}
