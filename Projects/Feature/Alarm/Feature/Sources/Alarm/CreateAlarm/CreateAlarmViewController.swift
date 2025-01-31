//
//  CreateAlarmViewController.swift
//  FeatureAlarm
//
//  Created by ever on 12/30/24.
//

import RIBs
import RxSwift
import UIKit
import FeatureDesignSystem

enum CreateAlarmPresentableListenerRequest {
    case viewDidLoad
    case back
    case meridiemChanged(MeridiemItem)
    case hourChanged(Int)
    case minuteChanged(Int)
    case selectedDaysChanged(Set<DayOfWeek>)
    case selectSnooze
    case selectSound
    case done
}

protocol CreateAlarmPresentableListener: AnyObject {
    func request(_ request: CreateAlarmPresentableListenerRequest)
}

final class CreateAlarmViewController: UIViewController, CreateAlarmPresentable, CreateAlarmViewControllable {

    weak var listener: CreateAlarmPresentableListener?
        
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        listener?.request(.viewDidLoad)
    }
    
    func request(_ request: CreateAlarmPresentableRequest) {
        switch request {
        case let .alarmUpdated(alarm):
            mainView.update(state: .alarmUpdated(alarm))
        }
    }
    
    private let mainView = CreateAlarmView()
    
    private func setupNavigation() {
        navigationController?.isNavigationBarHidden = true
    }
}

extension CreateAlarmViewController: CreateAlarmViewListener {
    func action(_ action: CreateAlarmView.Action) {
        switch action {
        case .backButtonTapped:
            listener?.request(.back)
        case let .meridiemChanged(meridiem):
            listener?.request(.meridiemChanged(meridiem))
        case let .hourChanged(hour):
            listener?.request(.hourChanged(hour))
        case let .minuteChanged(minute):
            listener?.request(.minuteChanged(minute))
        case let .selectWeekday(set):
            listener?.request(.selectedDaysChanged(set))
        case .snoozeButtonTapped:
            listener?.request(.selectSnooze)
        case .soundButtonTapped:
            listener?.request(.selectSound)
        case .doneButtonTapped:
            listener?.request(.done)
        }
    }
}
