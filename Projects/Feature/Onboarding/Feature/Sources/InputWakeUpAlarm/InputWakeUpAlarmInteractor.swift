//
//  InputWakeUpAlarmInteractor.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/4/25.
//

import FeatureCommonDependencies
import FeatureResources
import FeatureLogger

import RIBs
import RxSwift

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
    // Dependency
    private let logger: Logger

    weak var router: InputWakeUpAlarmRouting?
    weak var listener: InputWakeUpAlarmListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: InputWakeUpAlarmPresentable,
        logger: Logger,
        model: OnboardingModel
    ) {
        self.model = model
        self.logger = logger
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
            let log = PageViewLogBuilder(event: .alarm).build()
            logger.send(log)
            presenter.request(.setAlarm(model.alarm))
        case .exitPage:
            listener?.request(.back)
        case .confirmUserInputAndExit:
            let log = PageActionBuilder(event: .alarmCreate)
                .setProperty(key: "step", value: "초기 알람 생성")
                .build()
            logger.send(log)
            listener?.request(.next(model))
        case let .updateCurrentAlarmData(meridiem, hour, minute):
            model.alarm.meridiem = meridiem
            model.alarm.hour = hour
            model.alarm.minute = minute
        }
    }
}
