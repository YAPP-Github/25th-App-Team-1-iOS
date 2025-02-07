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

enum MainPageRouterRequest {
    case routeToCreateEditAlarm(mode: AlarmCreateEditMode)
    case detachCreateEditAlarm
    case presentAlert(DSButtonAlert.Config, DSButtonAlertViewControllerListener)
    case dismissAlert(completion: (()->Void)?=nil)
}
protocol MainPageRouting: ViewableRouting {
    func request(_ request: MainPageRouterRequest)
}

enum MainPagePresentableRequest {
    case setAlarmList([Alarm])
}

protocol MainPagePresentable: Presentable {
    var listener: MainPagePresentableListener? { get set }
    func request(_ request: MainPagePresentableRequest)
}

protocol MainPageListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

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
            break
        case .createAlarm:
            router?.request(.routeToCreateEditAlarm(mode: .create))
        case .changeAlarmState(let alarmId, let changeToActive):
            break
        case .deleteAlarm(let alarmId):
            break
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
            print(service.getAllAlarm().count)
        }
    }
}
