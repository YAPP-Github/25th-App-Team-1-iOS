//
//  ShakeMissionMainInteractor.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 1/20/25.
//

import FeatureUIDependencies
import Foundation
import RIBs
import RxSwift
import FeatureCommonDependencies
import FeatureNetworking

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

public enum ShakeMissionMainListenerRequest {
    case missionCompleted(Fortune, FortuneSaveInfo)
    case close(Fortune, FortuneSaveInfo)
}

public protocol ShakeMissionMainListener: AnyObject {
    func request(_ request: ShakeMissionMainListenerRequest)
}

final class ShakeMissionMainInteractor: PresentableInteractor<ShakeMissionMainPresentable>, ShakeMissionMainInteractable, ShakeMissionMainPresentableListener, DSTwoButtonAlertViewControllerListener {

    weak var router: ShakeMissionMainRouting?
    weak var listener: ShakeMissionMainListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: ShakeMissionMainPresentable,
        isFirstAlarm: Bool
    ) {
        self.isFirstAlarm = isFirstAlarm
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        if let fortuneInfo = UserDefaults.standard.dailyFortune() {
            getFortune(fortuneId: fortuneInfo.id)
        } else {
            createFortune()
        }
    }
    
    private func createFortune() {
        guard let userId = Preference.userId else { return }
        let request = APIRequest.Fortune.createFortune(userId: userId)
        APIClient.request(Fortune.self, request: request) { [weak self] fortune in
            guard let self else { return }
            self.fortune = fortune
            let info = FortuneSaveInfo(
                id: fortune.id,
                isFirstAlarm: isFirstAlarm,
                charmIndex: nil
            )
            self.fortuneInfo = info
            UserDefaults.standard.setDailyFortune(info: info)
        } failure: { error in
            print(error)
        }

    }
    
    private func getFortune(fortuneId: Int) {
        guard let fortuneInfo = UserDefaults.standard.dailyFortune() else { return }
        let request = APIRequest.Fortune.getFortune(fortuneId: fortuneId)
        APIClient.request(Fortune.self, request: request) { [weak self] fortune in
            self?.fortune = fortune
            self?.fortuneInfo = fortuneInfo
        } failure: { error in
            print(error)
        }
    }
    
    private var fortune: Fortune?
    private var fortuneInfo: FortuneSaveInfo?
    private let isFirstAlarm: Bool
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
            guard let fortune, let fortuneInfo else { return }
            listener?.request(.close(fortune, fortuneInfo))
        }
    }
}


// MARK: ShakeMissionWorkingListener
extension ShakeMissionMainInteractor {
    
    func exitShakeMissionWorkingPage(isSucceeded: Bool) {
        router?.request(.dissmissWorkingPage)
        router?.request(.exitPage)
        guard let fortune, let fortuneInfo else { return }
        if isSucceeded {
            listener?.request(.missionCompleted(fortune, fortuneInfo))
        } else {
            listener?.request(.close(fortune, fortuneInfo))
        }
        
    }
}
