//
//  ShakeMissionMainInteractor.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 1/20/25.
//

import Foundation

import FeatureUIDependencies
import FeatureCommonDependencies
import FeatureNetworking

import RIBs
import RxSwift

public enum ShakeMissionMainRoutingRequest {
    case presentWorkingPage
    case dissmissWorkingPage
    case presentAlert(DSTwoButtonAlert.Config)
    case dismissAlert(completion: (()->Void)?=nil)
}

public protocol ShakeMissionMainRouting: ViewableRouting {
    func request(_ request: ShakeMissionMainRoutingRequest)
}


protocol ShakeMissionMainPresentable: Presentable {
    var listener: ShakeMissionMainPresentableListener? { get set }
}

public enum ShakeMissionMainListenerRequest {
    case missionCompleted(Fortune, FortuneSaveInfo)
    case close(Fortune?, FortuneSaveInfo?)
}

public protocol ShakeMissionMainListener: AnyObject {
    func request(_ request: ShakeMissionMainListenerRequest)
}

final class ShakeMissionMainInteractor: PresentableInteractor<ShakeMissionMainPresentable>, ShakeMissionMainInteractable, ShakeMissionMainPresentableListener {

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
                shouldShowCharm: false,
                charmIndex: nil
            )
            UserDefaults.standard.setDailyFortune(info: info)
        } failure: { error in
            print(error)
        }

    }
    
    private func getFortune(fortuneId: Int) {
        let request = APIRequest.Fortune.getFortune(fortuneId: fortuneId)
        APIClient.request(Fortune.self, request: request) { [weak self] fortune in
            self?.fortune = fortune
        } failure: { error in
            print(error)
        }
    }
    
    private var fortune: Fortune?
    private let isFirstAlarm: Bool
}


// MARK: ShakeMissionMainPresentableListener
extension ShakeMissionMainInteractor {
    func request(_ request: ShakeMissionMainPresenterRequest) {
        switch request {
        case .startMission:
            router?.request(.presentWorkingPage)
        case .exitPage:
            let alertConfig: DSTwoButtonAlert.Config = .init(
                titleText: "나가면 운세를 받을 수 없어요",
                subTitleText: "미션을 수행하지 않고 나가시겠어요?",
                leftButtonText: "취소",
                rightButtonText: "나가기",
                leftButtonTapped: { [weak self] in
                    guard let self else { return }
                    router?.request(.dismissAlert())
                },
                rightButtonTapped: { [weak self] in
                    guard let self else { return }
                    listener?.request(.close(nil, nil))
                }
            )
            router?.request(.presentAlert(alertConfig))
        }
    }
}


// MARK: ShakeMissionWorkingListener
extension ShakeMissionMainInteractor {
    func request(request: ShakeMissionWorkingListenerRequest) {
        
        guard let fortune, var fortuneInfo = UserDefaults.standard.dailyFortune() else { return }
        
        switch request {
        case .exitPage(let isMissionCompleted):
            if isMissionCompleted {
                if fortuneInfo.shouldShowCharm == false {
                    fortuneInfo.shouldShowCharm = isFirstAlarm
                }
                UserDefaults.standard.setDailyFortune(info: fortuneInfo)
                listener?.request(.missionCompleted(fortune, fortuneInfo))
            } else {
                listener?.request(.close(fortune, fortuneInfo))
            }
        }
    }
}
