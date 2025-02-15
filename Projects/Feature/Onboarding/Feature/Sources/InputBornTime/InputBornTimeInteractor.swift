//
//  InputBornTimeInteractor.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import RIBs
import RxSwift
import FeatureCommonDependencies

protocol InputBornTimeRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

enum InputBornTimePresentableRequest {
    case setBornTIme(BornTimeData)
    case startEdit
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
    case next(OnboardingModel)
}

protocol InputBornTimeListener: AnyObject {
    func request(_ request: InputBornTimeListenerRequest)
}

final class InputBornTimeInteractor: PresentableInteractor<InputBornTimePresentable>, InputBornTimeInteractable, InputBornTimePresentableListener {

    weak var router: InputBornTimeRouting?
    weak var listener: InputBornTimeListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: InputBornTimePresentable,
        model: OnboardingModel
    ) {
        self.model = model
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    func request(_ request: InputBornTimePresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            if let bornTime = model.bornTime {
                presenter.request(.setBornTIme(bornTime))
            }
            presenter.request(.startEdit)
        case .back:
            listener?.request(.back)
        case let .timeChanged(time):
            resetTime()
            presenter.request(.updateButton(canGoNext))
            
            guard checkTimeLength(time) else {
                presenter.request(.showShortLenghError)
                return
            }
            
            guard let (meridiem, hour) = validateHour(time),
                  let minute = validateMinute(time) else {
                presenter.request(.showInvalidBornTimeError)
                return
            }
            
            model.bornTime = .init(meridiem: meridiem, hour: hour, minute: minute)
            
            presenter.request(.updateButton(canGoNext))
        case .iDontKnowButtonTapped:
            resetTime()
            listener?.request(.next(model))
        case .next:
            guard canGoNext else { return }
            listener?.request(.next(model))
        }
    }
    
    private func resetTime() {
        model.bornTime = nil
    }
    
    private var model: OnboardingModel
    
    private var isValidTime: Bool {
        model.bornTime != nil
    }
    
    private var canGoNext: Bool {
        isValidTime
    }
    
    private func checkTimeLength(_ time: String) -> Bool {
        let text = time.replacingOccurrences(of: ":", with: "")
        return text.count == 4
    }
    
    private func validateHour(_ time: String) -> (Meridiem, Hour)? {
        let hourString = time.prefix(2)
        guard var hourInt = Int(hourString),
              (0...23).contains(hourInt) else { return nil }
        let meridiem: Meridiem = hourInt < 12 ? .am : .pm
        
        if hourInt == 0 {
            hourInt = 12
        } else if hourInt > 12 {
            hourInt -= 12
        }
        guard let hour = Hour(hourInt) else { return nil }
        
        return (meridiem, hour)
    }
    
    private func validateMinute(_ time: String) -> Minute? {
        let minute = time.suffix(2)
        guard let minuteInt = Int(minute),
              (0...59).contains(minuteInt),
              let minute = Minute(minuteInt)
        else { return nil }
        
        return minute
    }
}
