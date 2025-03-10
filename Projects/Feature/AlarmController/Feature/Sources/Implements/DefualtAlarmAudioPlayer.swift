//
//  DefualtAlarmAudioController.swift
//  FeatureAlarmController
//
//  Created by choijunios on 3/8/25.
//

import AVFoundation

public class DefualtAlarmAudioController: AlarmAudioController {
    // State
    private var audioDict: [String: AVAudioPlayer] = [:]
    private let audioDictLock = NSLock()
    
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
        audioDictLock.lock()
        defer { audioDictLock.unlock() }
        audioDict[id] = player
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
        audioDictLock.lock()
        defer { audioDictLock.unlock() }
        switch matchingType {
        case .exact:
            guard let player = audioDict[id] else { return }
            player.stop()
            audioDict.removeValue(forKey: id)
        case .contains:
            audioDict.keys
                .filter({ $0.contains(id) })
                .forEach { matchedId in
                    let player = audioDict[id]!
                    player.stop()
                    audioDict.removeValue(forKey: id)
                }
        }
    }
}
