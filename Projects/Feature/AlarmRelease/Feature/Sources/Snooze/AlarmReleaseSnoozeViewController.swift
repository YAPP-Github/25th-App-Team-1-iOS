//
//  AlarmReleaseSnoozeViewController.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/12/25.
//

import RIBs
import RxSwift
import UIKit

enum AlarmReleaseSnoozePresentableListenerRequest {
    case viewDidLoad
    case releaseAlarm
    case snoozeFinished
}

protocol AlarmReleaseSnoozePresentableListener: AnyObject {
    func request(_ request: AlarmReleaseSnoozePresentableListenerRequest)
}

final class AlarmReleaseSnoozeViewController: UIViewController, AlarmReleaseSnoozePresentable, AlarmReleaseSnoozeViewControllable {

    weak var listener: AlarmReleaseSnoozePresentableListener?
    
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listener?.request(.viewDidLoad)
    }
    
    func request(_ request: AlarmReleaseSnoozePresentableRequest) {
        switch request {
        case .startTimer(let snoozeOption):
            mainView.update(.startTimer(snoozeOption))
        }
    }
    
    private let mainView = AlarmReleaseSnoozeView()
}

extension AlarmReleaseSnoozeViewController: AlarmReleaseSnoozeViewListener {
    func action(_ action: AlarmReleaseSnoozeView.Action) {
        switch action {
        case .releaseAlarmButtonTapped:
            listener?.request(.releaseAlarm)
        case .timerFinished:
            listener?.request(.snoozeFinished)
        }
    }
}
