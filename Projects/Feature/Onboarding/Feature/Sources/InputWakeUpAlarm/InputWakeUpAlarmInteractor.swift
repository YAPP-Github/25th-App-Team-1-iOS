//
//  InputWakeUpAlarmInteractor.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/4/25.
//

import RIBs
import RxSwift

protocol InputWakeUpAlarmRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol InputWakeUpAlarmPresentable: Presentable {
    var listener: InputWakeUpAlarmPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol InputWakeUpAlarmListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class InputWakeUpAlarmInteractor: PresentableInteractor<InputWakeUpAlarmPresentable>, InputWakeUpAlarmInteractable, InputWakeUpAlarmPresentableListener {

    weak var router: InputWakeUpAlarmRouting?
    weak var listener: InputWakeUpAlarmListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: InputWakeUpAlarmPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}


// MARK: InputWakeUpAlarmPresentableListener
extension InputWakeUpAlarmInteractor {
    
    func request(_ request: InputWakeUpAlarmPresenterRequest) {
        
        switch request {
        case .exitPage:
            print("알람 설정 페이지 이탈")
        case .confirmUserInputAndExit:
            print("알람데이터 확정")
        case .updateCurrentAlarmData(let alarmData):
            print("현재 알람 데이터 업데이트 \(alarmData)")
        }
    }
}
