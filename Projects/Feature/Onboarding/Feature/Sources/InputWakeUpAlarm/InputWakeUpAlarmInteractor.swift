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

protocol InputWakeUpAlarmPresentable: Presentable {
    var listener: InputWakeUpAlarmPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

enum InputWakeUpAlarmListenerRequest {
    case back
    case next(Alarm)
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
        alarmData = Alarm(
            meridiem: .am,
            hour: .init(6)!,
            minute: .init(0)!,
            repeatDays: AlarmDays(),
            snoozeOption: .init(isSnoozeOn: true, frequency: .fiveMinutes, count: .fiveTimes),
            soundOption: .init(isVibrationOn: true, isSoundOn: true, volume: 0.7, selectedSound: R.AlarmSound.allCases.sorted(by: { $0.title < $1.title }).first?.title ?? "")
        )
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    private var alarmData: Alarm
}


// MARK: InputWakeUpAlarmPresentableListener
extension InputWakeUpAlarmInteractor {
    
    func request(_ request: InputWakeUpAlarmPresenterRequest) {
        
        switch request {
        case .exitPage:
            listener?.request(.back)
        case .confirmUserInputAndExit:
            listener?.request(.next(alarmData))
        case let .updateCurrentAlarmData(meridiem, hour, minute):
            alarmData.meridiem = meridiem
            alarmData.hour = hour
            alarmData.minute = minute
            print("현재 알람 데이터 업데이트 \(alarmData)")
        }
    }
}
