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

enum InputBornTimePresentableRequest {
    case showShortLenghError
    case showInvalidBornTimeError
}

protocol InputBornTimePresentable: Presentable {
    var listener: InputBornTimePresentableListener? { get set }
    func request(_ request: InputBornTimePresentableRequest)
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
            guard checkTimeLength(time) else {
                presenter.request(.showShortLenghError)
                return
            }
            
            guard validateHour(time), validateMinute(time) else {
                presenter.request(.showInvalidBornTimeError)
                return
            }
        case .iDontKnowButtonTapped:
            shouldSkip.toggle()
        }
    }
    
    var time: String = ""
    var shouldSkip: Bool = false
    
    func checkTimeLength(_ time: String) -> Bool {
        let text = time.replacingOccurrences(of: ":", with: "")
        return text.count == 4
    }
    
    func validateHour(_ time: String) -> Bool {
        let hour = time.prefix(2)
        guard let hourInt = Int(hour) else { return false }
        return hourInt >= 0 && hourInt <= 23
    }
    
    func validateMinute(_ time: String) -> Bool {
        let minute = time.suffix(2)
        guard let minuteInt = Int(minute) else { return false }
        return minuteInt >= 0 && minuteInt <= 59
    }
}
