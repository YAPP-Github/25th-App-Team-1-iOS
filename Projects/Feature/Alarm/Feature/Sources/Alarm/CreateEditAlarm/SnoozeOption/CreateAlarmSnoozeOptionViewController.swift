//
//  CreateEditAlarmSnoozeOptionViewController.swift
//  FeatureAlarm
//
//  Created by ever on 1/20/25.
//

import RIBs
import RxSwift
import UIKit
import FeatureCommonDependencies

enum CreateEditAlarmSnoozeOptionPresentableListenerRequest {
    case viewDidLoad
    case cancel
    case isOnChanged(Bool)
    case frequencyChanged(SnoozeFrequency)
    case countChanged(SnoozeCount)
    case done
}

protocol CreateEditAlarmSnoozeOptionPresentableListener: AnyObject {
    func request(_ request: CreateEditAlarmSnoozeOptionPresentableListenerRequest)
}

final class CreateEditAlarmSnoozeOptionViewController: UIViewController, CreateEditAlarmSnoozeOptionPresentable, CreateEditAlarmSnoozeOptionViewControllable {

    weak var listener: CreateEditAlarmSnoozeOptionPresentableListener?
    
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listener?.request(.viewDidLoad)
    }
    
    func request(_ request: CreateEditAlarmSnoozeOptionPresentableRequest) {
        switch request {
        case let .updateOption(option):
            mainView.updateOption(option: option)
        }
    }
    
    private let mainView = CreateEditAlarmSnoozeOptionView()
}

extension CreateEditAlarmSnoozeOptionViewController: CreateEditAlarmSnoozeOptionViewListener {
    func action(_ action: CreateEditAlarmSnoozeOptionView.Action) {
        switch action {
        case .backgroundTapped:
            listener?.request(.cancel)
        case let .isOnChanged(isOn):
            listener?.request(.isOnChanged(isOn))
        case let .frequencyChanged(frequency):
            listener?.request(.frequencyChanged(frequency))
        case let .countChanged(count):
            listener?.request(.countChanged(count))
        case .doneButtonTapped:
            listener?.request(.done)
        }
    }
}
