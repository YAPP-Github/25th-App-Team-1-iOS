//
//  ShakeMissionMainInteractor.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 1/20/25.
//

import FeatureUIDependencies

import RIBs
import RxSwift

public enum ShakeMissionMainRoutingRequest {
    case presentWorkingPage
    case dissmissWorkingPage
    case presentAlert(DSTwoButtonAlert.Config, DSTwoButtonAlertViewControllerListener)
    case dismissAlert(completion: (()->Void)?=nil)
    case exitPage
}

public protocol ShakeMissionMainRouting: ViewableRouting {
    
    func request(_ request: ShakeMissionMainRoutingRequest)
}


protocol ShakeMissionMainPresentable: Presentable {
    var listener: ShakeMissionMainPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol ShakeMissionMainListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ShakeMissionMainInteractor: PresentableInteractor<ShakeMissionMainPresentable>, ShakeMissionMainInteractable, ShakeMissionMainPresentableListener, DSTwoButtonAlertViewControllerListener {

    weak var router: ShakeMissionMainRouting?
    weak var listener: ShakeMissionMainListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ShakeMissionMainPresentable) {
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


// MARK: ShakeMissionMainPresentableListener
extension ShakeMissionMainInteractor {
    
    func request(_ request: ShakeMissionMainPresenterRequest) {
        switch request {
        case .startMission:
            router?.request(.presentWorkingPage)
        case .presentAlert(let config):
            router?.request(.presentAlert(config, self))
        }
    }
}


// MARK: DSTwoButtonAlertViewControllerListener
extension ShakeMissionMainInteractor {
    
    func action(_ action: DSTwoButtonAlertViewController.Action) {
        switch action {
        case .leftButtonClicked:
            router?.request(.dismissAlert())
        case .rightButtonClicked:
            router?.request(.exitPage)
        }
    }
}


// MARK: ShakeMissionWorkingListener
extension ShakeMissionMainInteractor {
    
    func exitShakeMissionWorkingPage() {
        router?.request(.dissmissWorkingPage)
    }
}
