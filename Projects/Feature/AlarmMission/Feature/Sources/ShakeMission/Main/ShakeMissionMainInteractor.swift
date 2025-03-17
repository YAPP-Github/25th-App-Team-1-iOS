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
import FeatureLogger

import RIBs
import RxSwift
import RxRelay

enum ShakeMissionMainRoutingRequest {
    case presentWorkingPage
    case dissmissWorkingPage(completion: (()->Void)?=nil)
    case presentAlert(DSTwoButtonAlert.Config)
    case dismissAlert(completion: (()->Void)?=nil)
}

protocol ShakeMissionMainRouting: ViewableRouting {
    func request(_ request: ShakeMissionMainRoutingRequest)
}


protocol ShakeMissionMainPresentable: Presentable {
    var listener: ShakeMissionMainPresentableListener? { get set }
}

protocol ShakeMissionMainListener: AnyObject { }

final class ShakeMissionMainInteractor: PresentableInteractor<ShakeMissionMainPresentable>, ShakeMissionMainInteractable, ShakeMissionMainPresentableListener {
    // Dependency
    private let logger: Logger
    

    weak var router: ShakeMissionMainRouting?
    weak var listener: ShakeMissionMainListener?
    
    
    // Stream
    private let missionAction: PublishRelay<MissionState>
    

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: ShakeMissionMainPresentable,
        missionAction: PublishRelay<MissionState>,
        logger: Logger
    ) {
        self.missionAction = missionAction
        self.logger = logger
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    deinit {
        print("흔들기 미션 인터렉터 deinit")
    }
}


// MARK: ShakeMissionMainPresentableListener
extension ShakeMissionMainInteractor {
    func request(_ request: ShakeMissionMainPresenterRequest) {
        switch request {
        case .startMission:
            let log = MissionActionLogBuilder(eventType: .missionStart, mission: .shake).build()
            logger.send(log)
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
                    let log = MissionActionLogBuilder(eventType: .skipMission, mission: .shake).build()
                    logger.send(log)
                    router?.request(.dismissAlert(completion: { [weak self] in
                        guard let self else { return }
                        missionAction.accept(.exitMission)
                    }))
                }
            )
            router?.request(.presentAlert(alertConfig))
        }
    }
}


// MARK: ShakeMissionWorkingListener
extension ShakeMissionMainInteractor {
    func request(request: ShakeMissionWorkingListenerRequest) {
        switch request {
        case .exitPage(let isMissionCompleted):
            router?.request(.dissmissWorkingPage(completion: { [weak self] in
                guard let self else { return }
                missionAction.accept(isMissionCompleted ? .missionIsCompleted : .exitMission)
            }))
        }
    }
}
