//
//  MainPageInteractor.swift
//  FeatureMain
//
//  Created by choijunios on 1/27/25.
//

import RIBs
import RxSwift
import FeatureDesignSystem
import FeatureAlarm
import FeatureCommonDependencies

public enum MainPageRouterRequest {
    case routeToCreateEditAlarm(mode: AlarmCreateEditMode)
    case detachCreateEditAlarm
    case routeToAlarmMission
    case detachAlarmMission
    case presentAlert(DSButtonAlert.Config, DSButtonAlertViewControllerListener)
    case dismissAlert(completion: (()->Void)?=nil)
}

public protocol MainPageRouting: ViewableRouting {
    func request(_ request: MainPageRouterRequest)
}

enum MainPagePresentableRequest {
    case setAlarmList([Alarm])
}

protocol MainPagePresentable: Presentable {
    var listener: MainPagePresentableListener? { get set }
    func request(_ request: MainPagePresentableRequest)
}

public protocol MainPageListener: AnyObject {}

final class MainPageInteractor: PresentableInteractor<MainPagePresentable>, MainPageInteractable, MainPagePresentableListener {
    
    weak var router: MainPageRouting?
    weak var listener: MainPageListener?
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: MainPagePresentable,
        service: MainPageServiceable
    ) {
        self.service = service
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    private let service: MainPageServiceable
}


extension MainPageInteractor {
    func request(_ request: MainPageViewPresenterRequest) {
        switch request {
        case .viewDidLoad:
            let alarmList = service.getAllAlarm()
            presenter.request(.setAlarmList(alarmList))
        case .showFortuneNoti:
            let config = DSButtonAlert.Config(
                titleText: "받은 운세가 없어요",
                subTitleText: """
                알람이 울린 후 미션을 수행하면
                오늘의 운세를 받을 수 있어요.
                """,
                buttonText: "닫기")
            router?.request(.presentAlert(config, self))
        case .goToSettings:
            router?.request(.routeToAlarmMission)
        case .createAlarm:
            router?.request(.routeToCreateEditAlarm(mode: .create))
        case let .editAlarm(alarm):
            router?.request(.routeToCreateEditAlarm(mode: .edit(alarm)))
        case let .changeAlarmState(alarmId, isActive):
            guard var alarm = service.getAllAlarm().first(where: { $0.id == alarmId }) else { return }
            alarm.isActive = isActive
            service.updateAlarm(alarm)
            let newAlarmList = service.getAllAlarm()
            presenter.request(.setAlarmList(newAlarmList))
        case let .deleteAlarm(alarmId):
            guard let alarm = service.getAllAlarm().first(where: { $0.id == alarmId }) else { return }
            service.deleteAlarm(alarm)
            let newAlarmList = service.getAllAlarm()
            presenter.request(.setAlarmList(newAlarmList))
        }
    }
}

extension MainPageInteractor: DSButtonAlertViewControllerListener {
    func action(_ action: DSButtonAlertViewController.Action) {
        switch action {
        case .buttonClicked:
            router?.request(.dismissAlert())
        }
    }
}

extension MainPageInteractor {
    func reqeust(_ request: RootListenerRequest) {
        router?.request(.detachCreateEditAlarm)
        switch request {
        case .close:
            break
        case let .done(alarm):
            service.addAlarm(alarm)
            let newAlarmList = service.getAllAlarm()
            presenter.request(.setAlarmList(newAlarmList))
        case let .updated(alarm):
            service.updateAlarm(alarm)
            let newAlarmList = service.getAllAlarm()
            presenter.request(.setAlarmList(newAlarmList))
        case let .deleted(alarm):
            service.deleteAlarm(alarm)
            let newAlarmList = service.getAllAlarm()
            presenter.request(.setAlarmList(newAlarmList))
        }
    }
}
