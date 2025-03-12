//
//  DefualtAlarmAudioController.swift
//  FeatureAlarmController
//
//  Created by choijunios on 3/8/25.
//

import AVFoundation

extension AVAudioPlayer: WorkCancellable {
    func cancel() { self.stop() }
}

public class DefualtAlarmAudioController: AlarmAudioController {
    // State
    private let audioContainer = WorkContainer<AVAudioPlayer>()
    
    public init() { }
    
    private func setupSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.duckOthers])
            try audioSession.setActive(true)
        } catch {
            debugPrint("\(Self.self), 오디오 세션 설정 실패 \(error.localizedDescription)")
        }
    }
    
    private func register(id: String, player: AVAudioPlayer) {
        audioContainer.add(key: id, item: player)
    }
}


// MARK: AlarmAudioPlayer
public extension DefualtAlarmAudioController {
    func play(id: String, audioURL: URL, volume: Float = 1.0) {
        do {
            setupSession()
            let player = try AVAudioPlayer(contentsOf: audioURL)
            player.numberOfLoops = 20
            player.volume = volume
            player.prepareToPlay()
            player.play()
            register(id: id, player: player)
        } catch {
            debugPrint("\(Self.self) 알람 오디오 파일을 재생할 수 없음 \(error.localizedDescription)")
        }
    }
    
    func stopAndRemove(matchingType: IdMatchingType, id: String) {
        switch matchingType {
        case .exact:
            audioContainer.cancelAndRemove(key: id)
        case .contains:
            let willCancelIds = audioContainer.containsKey(id: id)
            audioContainer.cancelAndRemove(keys: willCancelIds)
        }
    }
}
