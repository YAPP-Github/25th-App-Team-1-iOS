//
//  CreateEditAlarmViewController.swift
//  FeatureAlarm
//
//  Created by ever on 12/30/24.
//

import RIBs
import RxSwift
import UIKit
import FeatureDesignSystem
import FeatureCommonDependencies

enum CreateEditAlarmPresentableListenerRequest {
    case viewDidLoad
    case back
    case delete
    case meridiemChanged(Meridiem)
    case hourChanged(Hour)
    case minuteChanged(Minute)
    case selectedDaysChanged(AlarmDays)
    case selectSnooze
    case selectSound
    case done
}

protocol CreateEditAlarmPresentableListener: AnyObject {
    func request(_ request: CreateEditAlarmPresentableListenerRequest)
}

final class CreateEditAlarmViewController: UIViewController, CreateEditAlarmPresentable, CreateEditAlarmViewControllable {

    weak var listener: CreateEditAlarmPresentableListener?
        
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        listener?.request(.viewDidLoad)
    }
    
    func request(_ request: CreateEditAlarmPresentableRequest) {
        switch request {
        case .showDeleteButton:
            mainView.update(state: .showDeleteButton)
        case let .updateTitle(title):
            mainView.update(state: .titleUpdated(title))
        case let .alarmUpdated(alarm):
            mainView.update(state: .alarmUpdated(alarm))
        }
    }
    
    private let mainView = CreateEditAlarmView()
    
    private func setupNavigation() {
        navigationController?.isNavigationBarHidden = true
    }
    
    deinit {
        print(#function)
    }
}

extension CreateEditAlarmViewController: CreateEditAlarmViewListener {
    func action(_ action: CreateEditAlarmView.Action) {
        switch action {
        case .backButtonTapped:
            listener?.request(.back)
        case .deleteButtonTapped:
            listener?.request(.delete)
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
