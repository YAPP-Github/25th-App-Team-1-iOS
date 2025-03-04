//
//  TapMissionMainInteractor.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 3/4/25.
//

import FeatureUIDependencies

import RIBs
import RxSwift
import RxRelay

enum TapMissionMainRoutingRequest {
    case presentWorkingPage
    case dissmissWorkingPage
    case presentAlert(DSTwoButtonAlert.Config)
    case dismissAlert(completion: (()->Void)?=nil)
}




protocol TapMissionMainRouting: ViewableRouting {
    func request(_ request: ShakeMissionMainRoutingRequest)
}

protocol TapMissionMainPresentable: Presentable {
    var listener: TapMissionMainPresentableListener? { get set }
}

protocol TapMissionMainListener: AnyObject { }


final class TapMissionMainInteractor: PresentableInteractor<TapMissionMainPresentable>, TapMissionMainInteractable, TapMissionMainPresentableListener {

    weak var router: TapMissionMainRouting?
    weak var listener: TapMissionMainListener?
    
    
    // Stream
    private let missionAction: PublishRelay<MissionState>
    

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: TapMissionMainPresentable, missionAction: PublishRelay<MissionState>) {
        self.missionAction = missionAction
        super.init(presenter: presenter)
        presenter.listener = self
    }
}


// MARK: TapMissionMainPresentableListener
extension TapMissionMainInteractor {
    func request(_ request: TapMissionMainPresenterRequest) {
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
                    missionAction.accept(.exitMission)
                }
            )
            router?.request(.presentAlert(alertConfig))
        }
    }
}


// MARK: TapMissionWorkingListener
extension TapMissionMainInteractor {
    func request(request: TapMissionWorkingListenerRequest) {
        router?.request(.dissmissWorkingPage)
        switch request {
        case .exitPage(let isMissionCompleted):
            if isMissionCompleted {
                missionAction.accept(.missionIsCompleted)
            } else {
                missionAction.accept(.exitMission)
            }
        }
    }
}
