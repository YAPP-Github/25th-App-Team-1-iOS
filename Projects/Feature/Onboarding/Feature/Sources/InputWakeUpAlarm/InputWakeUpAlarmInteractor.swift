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

enum InputWakeUpAlarmListenerRequest {
    case back
    case next(AlarmData)
}

protocol InputWakeUpAlarmListener: AnyObject {
    func request(_ request:InputWakeUpAlarmListenerRequest)
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
    
    private var alarmData: AlarmData?
}


// MARK: InputWakeUpAlarmPresentableListener
extension InputWakeUpAlarmInteractor {
    
    func request(_ request: InputWakeUpAlarmPresenterRequest) {
        
        switch request {
        case .exitPage:
            listener?.request(.back)
        case .confirmUserInputAndExit:
            guard let alarmData else { return }
            listener?.request(.next(alarmData))
        case .updateCurrentAlarmData(let alarmData):
            self.alarmData = alarmData
            print("현재 알람 데이터 업데이트 \(alarmData)")
        }
    }
}
