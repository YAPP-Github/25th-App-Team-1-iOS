//
//  ShakeMissionWorkingInteractor.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 1/20/25.
//

import FeatureDesignSystem

import RIBs
import RxSwift

protocol ShakeMissionWorkingRouting: ViewableRouting {
    func request(_ request: ShakeMissionWorkingRoutingRequest)
}
enum ShakeMissionWorkingRoutingRequest {
    case presentAlert(DSTwoButtonAlert.Config, DSTwoButtonAlertViewControllerListener)
    case dismissAlert(completion: (()->Void)?=nil)
}


protocol ShakeMissionWorkingPresentable: Presentable {
    var listener: ShakeMissionWorkingPresentableListener? { get set }
    
    func request(_ request: ShakeMissionWorkingInteractorRequest)
}
enum ShakeMissionWorkingInteractorRequest {
    case startShakeMissionFlow(successShakeCount: Int)
}


protocol ShakeMissionWorkingListener: AnyObject {
    func exitShakeMissionWorkingPage()
}

final class ShakeMissionWorkingInteractor: PresentableInteractor<ShakeMissionWorkingPresentable>, ShakeMissionWorkingInteractable, ShakeMissionWorkingPresentableListener, DSTwoButtonAlertViewControllerListener {

    weak var router: ShakeMissionWorkingRouting?
    weak var listener: ShakeMissionWorkingListener?
    
    
    // Mission configuration
    private let successShakeCount = 10
    private var currentShakeCount = 0
    

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ShakeMissionWorkingPresentable) {
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


// MARK: ShakeMissionWorkingPresentableListener
extension ShakeMissionWorkingInteractor {
    
    func request(_ request: ShakeMissionWorkingPresenterRequest) {
        switch request {
        case .startMission:
            presenter.request(.startShakeMissionFlow(
                successShakeCount: successShakeCount
            ))
        case .shakeIsDetected:
            print("Shake 감지!!!")
        case .presentExitAlert(let config):
            router?.request(.presentAlert(config, self))
        }
    }
}


// MARK: DSTwoButtonAlertViewControllerListener
extension ShakeMissionWorkingInteractor {
    func action(_ action: DSTwoButtonAlertViewController.Action) {
        switch action {
        case .leftButtonClicked:
            router?.request(.dismissAlert())
        case .rightButtonClicked:
            let completion = { [weak self] in
                guard let self else { return }
                listener?.exitShakeMissionWorkingPage()
            }
            router?.request(.dismissAlert(completion: completion))
        }
    }
}
