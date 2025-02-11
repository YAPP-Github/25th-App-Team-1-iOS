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
        
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(timerFired),
            userInfo: nil,
            repeats: true
        )
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
        }
    }
    
    @objc
    private func timerFired() {
        mainView.update(.updateTime)
    }
    
    private let mainView = AlarmReleaseIntroView()
}

extension AlarmReleaseIntroViewController: AlarmReleaseIntroViewListener {
    func action(_ action: AlarmReleaseIntroView.Action) {
        switch action {
        case .snoozeButtonTapped:
            listener?.request(.snoozeAlarm)
            let vc = AlarmReleaseSnoozeViewController()
            self.present(vc, animated: true)
        case .releaseAlarmButtonTapped:
            timer?.invalidate()
            timer = nil
            listener?.request(.releaseAlarm)
        }
    }
}
