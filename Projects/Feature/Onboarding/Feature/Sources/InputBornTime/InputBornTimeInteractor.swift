//
//  InputBornTimeInteractor.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import RIBs
import RxSwift

protocol InputBornTimeRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol InputBornTimePresentable: Presentable {
    var listener: InputBornTimePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol InputBornTimeListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class InputBornTimeInteractor: PresentableInteractor<InputBornTimePresentable>, InputBornTimeInteractable, InputBornTimePresentableListener {

    weak var router: InputBornTimeRouting?
    weak var listener: InputBornTimeListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: InputBornTimePresentable) {
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
    
    func request(_ request: InputBornTimePresentableListenerRequest) {
        switch request {
        case let .timeChanged(time):
            self.time = time
        case .iDontKnowButtonTapped:
            shouldSkip.toggle()
        }
    }
    
    var time: String = ""
    var shouldSkip: Bool = false
}
