//
//  AlarmReleaseIntroViewController.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/10/25.
//

import RIBs
import RxSwift
import UIKit

enum AlarmReleaseIntroPresentableListenerRequest {
    case viewDidLoad
    case snoozeAlarm
    case releaseAlarm
}

protocol AlarmReleaseIntroPresentableListener: AnyObject {
    func request(_ request: AlarmReleaseIntroPresentableListenerRequest)
}

final class AlarmReleaseIntroViewController: UIViewController, AlarmReleaseIntroPresentable, AlarmReleaseIntroViewControllable {

    weak var listener: AlarmReleaseIntroPresentableListener?
    private var timer: Timer?

    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.timerFired()
        }
        listener?.request(.viewDidLoad)
    }
    
    func request(_ request: AlarmReleaseIntroPresentableRequest) {
        switch request {
        case let .updateSnooze(option):
            mainView.update(.snoozeOption(option))
        case let .updateSnoozeCount(count):
            mainView.update(.snoozeCount(count))
        case .hideSnoozeButton:
            mainView.update(.hideSnoozeButton)
        case .stopTimer:
            cleanupTimer()
        case let .hasMission(hasMission):
            mainView.update(.hasMission(hasMission))
        }
    }
    
    private func timerFired() {
        mainView.update(.updateTime)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cleanupTimer()
    }
    
    deinit {
        cleanupTimer()
    }
    
    private func cleanupTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private let mainView = AlarmReleaseIntroView()
}

extension AlarmReleaseIntroViewController: AlarmReleaseIntroViewListener {
    func action(_ action: AlarmReleaseIntroView.Action) {
        switch action {
        case .snoozeButtonTapped:
            listener?.request(.snoozeAlarm)
        case .releaseAlarmButtonTapped:
            cleanupTimer()
            listener?.request(.releaseAlarm)
        }
    }
}
