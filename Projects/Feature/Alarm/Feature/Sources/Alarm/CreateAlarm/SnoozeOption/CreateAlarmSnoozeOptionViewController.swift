//
//  CreateAlarmSnoozeOptionViewController.swift
//  FeatureAlarm
//
//  Created by ever on 1/20/25.
//

import RIBs
import RxSwift
import UIKit
import FeatureCommonDependencies

enum CreateAlarmSnoozeOptionPresentableListenerRequest {
    case viewDidLoad
    case isOnChanged(Bool)
    case frequencyChanged(SnoozeFrequency)
    case countChanged(SnoozeCount)
    case done
}

protocol CreateAlarmSnoozeOptionPresentableListener: AnyObject {
    func request(_ request: CreateAlarmSnoozeOptionPresentableListenerRequest)
}

final class CreateAlarmSnoozeOptionViewController: UIViewController, CreateAlarmSnoozeOptionPresentable, CreateAlarmSnoozeOptionViewControllable {

    weak var listener: CreateAlarmSnoozeOptionPresentableListener?
    
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listener?.request(.viewDidLoad)
    }
    
    func request(_ request: CreateAlarmSnoozeOptionPresentableRequest) {
        switch request {
        case let .updateOption(option):
            mainView.updateOption(option: option)
        }
    }
    
    private let mainView = CreateAlarmSnoozeOptionView()
}

extension CreateAlarmSnoozeOptionViewController: CreateAlarmSnoozeOptionViewListener {
    func action(_ action: CreateAlarmSnoozeOptionView.Action) {
        switch action {
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
