//
//  MainPageInteractor.swift
//  FeatureMain
//
//  Created by choijunios on 1/27/25.
//

import RIBs
import RxSwift
import FeatureDesignSystem

enum MainPageRouterRequest {
    case presentAlert(DSButtonAlert.Config, DSButtonAlertViewControllerListener)
    case dismissAlert(completion: (()->Void)?=nil)
}
protocol MainPageRouting: ViewableRouting {
    func request(_ request: MainPageRouterRequest)
}

protocol MainPagePresentable: Presentable {
    var listener: MainPagePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MainPageListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MainPageInteractor: PresentableInteractor<MainPagePresentable>, MainPageInteractable, MainPagePresentableListener {

    weak var router: MainPageRouting?
    weak var listener: MainPageListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: MainPagePresentable) {
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


extension MainPageInteractor {
    func request(_ request: MainPageViewPresenterRequest) {
        switch request {
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
