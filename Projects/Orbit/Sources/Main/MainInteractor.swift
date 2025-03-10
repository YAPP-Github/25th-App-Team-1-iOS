//
//  MainInteractor.swift
//  Orbit
//
//  Created by 손병근 on 1/4/25.
//

import Foundation
import RIBs
import RxSwift
import RxRelay
import FeatureOnboarding
import FeatureCommonDependencies
import FeatureResources
import FeatureMain
import UserNotifications
import FeatureAlarmCommon
import FeatureAlarmController

protocol RootActionableItem: AnyObject {
    func waitFoOnboarding() -> Observable<(MainPageActionableItem, ())>
}

protocol AlarmIdHandler: AnyObject {
    func handle(_ alarmId: String)
}

enum MainRouterRequest {
    case routeToOnboarding
    case detachOnboarding
    case routeToMain(((MainPageActionableItem) -> Void)?)
    case detachMain
}

protocol MainRouting: ViewableRouting {
    func request(_ request: MainRouterRequest)
}

protocol MainPresentable: Presentable {
    var listener: MainPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MainListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MainInteractor: PresentableInteractor<MainPresentable>, MainInteractable, MainPresentableListener {
    
    // Dependency
    private let alarmController: AlarmController

    weak var router: MainRouting?
    weak var listener: MainListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: MainPresentable, alarmController: AlarmController) {
        self.alarmController = alarmController
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        if Preference.isOnboardingFinished {
            router?.request(.routeToMain { [weak self] actionableItem in
                self?.mainPageActionableItemSubject.onNext(actionableItem)
            })
        } else {
            router?.request(.routeToOnboarding)
        }
    }
    
    private let mainPageActionableItemSubject = ReplaySubject<MainPageActionableItem>.create(bufferSize: 1)
}

// MARK: OnboardRootListenerRequest
extension MainInteractor {
    func request(_ request: RootListenerRequest) {
        switch request {
        case let .start(alarm):
            router?.request(.detachOnboarding)
            
            alarmController.createAlarm(alarm: alarm) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success:
                    debugPrint("온보딩 알람생성 성공")
                    alarmController.scheduleAlarm(alarm: alarm)
                case .failure(let error):
                    debugPrint("온보딩 알람생성 실패 \(error.localizedDescription)")
                }
            }
            
            router?.request(.routeToMain { [weak self] actionableItem in
                self?.mainPageActionableItemSubject.onNext(actionableItem)
            })
            
//            AlarmScheduler.shared.addAlarm(alarm)
        }
    }
}

extension MainInteractor: AlarmIdHandler {
    func handle(_ alarmId: String) {
        let alarmWorkFlow = AlarmWorkFlow(alarmId: alarmId)
        alarmWorkFlow
            .subscribe(self)
            .disposeOnDeactivate(interactor: self)
    }
}

extension MainInteractor: RootActionableItem {
    func waitFoOnboarding() -> Observable<(MainPageActionableItem, ())> {
        return mainPageActionableItemSubject
            .map { (mainPageItem: MainPageActionableItem) -> (MainPageActionableItem, ()) in
                    (mainPageItem, ())
                }
    }
}
