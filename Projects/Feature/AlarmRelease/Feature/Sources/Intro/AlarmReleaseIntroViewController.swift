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
    }
    
    @objc
    private func timerFired() {
        mainView.generateCurrentTime()
    }
    
    private let mainView = AlarmReleaseIntroView()
    
    deinit {
        timer?.invalidate()
    }
}

extension AlarmReleaseIntroViewController: AlarmReleaseIntroViewListener {
    func action(_ action: AlarmReleaseIntroView.Action) {
        switch action {
        case .snoozeButtonTapped:
            listener?.request(.snoozeAlarm)
        case .releaseAlarmButtonTapped:
            listener?.request(.releaseAlarm)
        }
    }
}
