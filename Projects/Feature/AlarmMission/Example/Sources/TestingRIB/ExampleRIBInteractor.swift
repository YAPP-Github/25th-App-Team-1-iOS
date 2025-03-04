//
//  ExampleRIBInteractor.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 3/4/25.
//

import RIBs
import RxSwift

import FeatureAlarmMission

protocol ExampleRIBRouting: ViewableRouting {
    func presentMission(_ mission: Mission)
    func dismissMission()
}

protocol ExampleRIBPresentable: Presentable {
    var listener: ExampleRIBPresentableListener? { get set }
    func request(_ request: ExampleRIBPresenterRequest)
}

enum ExampleRIBPresenterRequest {
    case setItems([Mission])
}


protocol ExampleRIBListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ExampleRIBInteractor: PresentableInteractor<ExampleRIBPresentable>, ExampleRIBInteractable, ExampleRIBPresentableListener {

    weak var router: ExampleRIBRouting?
    weak var listener: ExampleRIBListener?
    
    private let missions: [Mission] = [.shake, .tap]

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ExampleRIBPresentable) {
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
    
    func request(_ request: ExampleRIBPresentableListenerRequest) {
        switch request {
        case .viewIsReady:
            presenter.request(.setItems(missions))
        case .cellIsTapped(let index):
            let mission = missions[index]
            router?.presentMission(mission)
        }
    }
    
    func request(_ request: MissionRootListenerRequest) {
        switch request {
        case .missionCompleted(let fortune, let fortuneSaveInfo):
            router?.dismissMission()
        case .close(let fortune, let fortuneSaveInfo):
            router?.dismissMission()
        }
    }
}
