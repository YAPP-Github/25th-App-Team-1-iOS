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
    case updateButton(Bool)
}

protocol InputBornTimePresentable: Presentable {
    var listener: InputBornTimePresentableListener? { get set }
    func request(_ request: InputBornTimePresentableRequest)
}

enum InputBornTimeListenerRequest {
    case back
    case done(hour: Int, minute: Int)
    case skip
}

protocol InputBornTimeListener: AnyObject {
    func request(_ request: InputBornTimeListenerRequest)
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
        case .back:
            listener?.request(.back)
        case let .timeChanged(time):
            resetTime()
            presenter.request(.updateButton(canGoNext))
            
            guard checkTimeLength(time) else {
                presenter.request(.showShortLenghError)
                return
            }
            
            guard let hour = validateHour(time),
                  let minute = validateMinute(time) else {
                presenter.request(.showInvalidBornTimeError)
                return
            }
            self.hour = hour
            self.minute = minute
            
            isValidTime = true
            
            presenter.request(.updateButton(canGoNext))
        case .iDontKnowButtonTapped:
            resetTime()
            shouldSkip.toggle()
            presenter.request(.updateButton(canGoNext))
        case .next:
            guard !shouldSkip else {
                listener?.request(.skip)
                return
            }
            guard let hour, let minute else {
                return
            }
            listener?.request(.done(hour: hour, minute: minute))
        }
    }
    
    private func resetTime() {
        self.hour = nil
        self.minute = nil
        self.isValidTime = false
    }
    
    var hour: Int?
    var minute: Int?
    var shouldSkip: Bool = false
    var isValidTime: Bool = false
    var canGoNext: Bool {
        isValidTime || shouldSkip
    }
    
    func checkTimeLength(_ time: String) -> Bool {
        let text = time.replacingOccurrences(of: ":", with: "")
        return text.count == 4
    }
    
    func validateHour(_ time: String) -> Int? {
        let hour = time.prefix(2)
        guard let hourInt = Int(hour) else { return nil }
        if hourInt >= 0 && hourInt <= 23 {
            return hourInt
        }
        return nil
    }
    
    func validateMinute(_ time: String) -> Int? {
        let minute = time.suffix(2)
        guard let minuteInt = Int(minute) else { return nil }
        if minuteInt >= 0 && minuteInt <= 59 {
            return minuteInt
        }
        return nil
    }
}
