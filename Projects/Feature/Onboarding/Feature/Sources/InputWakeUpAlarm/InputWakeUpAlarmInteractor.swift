//
//  InputWakeUpAlarmInteractor.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/4/25.
//

import RIBs
import RxSwift
import FeatureCommonDependencies
import FeatureResources

protocol InputWakeUpAlarmRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

enum InputWakeUpAlarmPresentableRequest {
    case setAlarm(Alarm)
}

protocol InputWakeUpAlarmPresentable: Presentable {
    var listener: InputWakeUpAlarmPresentableListener? { get set }
    func request(_ request: InputWakeUpAlarmPresentableRequest)
}

enum InputWakeUpAlarmListenerRequest {
    case back
    case next(OnboardingModel)
}

protocol InputWakeUpAlarmListener: AnyObject {
    func request(_ request:InputWakeUpAlarmListenerRequest)
}

final class InputWakeUpAlarmInteractor: PresentableInteractor<InputWakeUpAlarmPresentable>, InputWakeUpAlarmInteractable, InputWakeUpAlarmPresentableListener {

    weak var router: InputWakeUpAlarmRouting?
    weak var listener: InputWakeUpAlarmListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: InputWakeUpAlarmPresentable,
        model: OnboardingModel
    ) {
        self.model = model
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    private var model: OnboardingModel
}


// MARK: InputWakeUpAlarmPresentableListener
extension InputWakeUpAlarmInteractor {
    
    func request(_ request: InputWakeUpAlarmPresenterRequest) {
        
        switch request {
        case .viewDidLoad:
            presenter.request(.setAlarm(model.alarm))
        case .exitPage:
            listener?.request(.back)
        case .confirmUserInputAndExit:
            listener?.request(.next(model))
        case let .updateCurrentAlarmData(meridiem, hour, minute):
            model.alarm.meridiem = meridiem
            model.alarm.hour = hour
            model.alarm.minute = minute
        }
    }
}
