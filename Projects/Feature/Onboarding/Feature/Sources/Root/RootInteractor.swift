//
//  RootInteractor.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import RIBs
import RxSwift

public enum RootRouterRequest {
    case cleanUpViews
    case routeToIntro
    case routeToInputName
    case routeToInputBornTime
    case routeToInputGender
    case routeToInputWakeUpAlarm
    case routeToInputBirthDate
    case detachInputBornTime
    case routeToAuthorizationRequest
    case detachAuthorizationRequest
    case routeToAuthorizationDenied
    case detachAuthorizationDenied
}

public protocol RootRouting: Routing {
    func request(_ request: RootRouterRequest)
}

public protocol RootListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RootInteractor: Interactor, RootInteractable {

    weak var router: RootRouting?
    weak var listener: RootListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(entryPoint: EntryPoint) {
        self.entryPoint = entryPoint
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        switch entryPoint {
        case .intro:
            router?.request(.routeToIntro)
        case .inputName:
            router?.request(.routeToInputName)
        case .inputBornTime:
            router?.request(.routeToInputBornTime)
        case .inputGender:
            router?.request(.routeToInputGender)
        case .inputWakeUpAlarm:
            router?.request(.routeToInputWakeUpAlarm)
        case .inputBirthDate:
            router?.request(.routeToInputBirthDate)
        case .authorizationRequest:
            router?.request(.routeToAuthorizationRequest)
        }
    }

    override func willResignActive() {
        super.willResignActive()

        router?.request(.cleanUpViews)
        // TODO: Pause any business logic.
    }
    
    private let entryPoint: EntryPoint
}

// MARK: InputBornTimeListenerRequest
extension RootInteractor {
    func request(_ request: InputBornTimeListenerRequest) {
        router?.request(.detachInputBornTime)
        switch request {
        case .skip:
            print("born time skip")
        case let .done(hour, minute):
            print("born hour: \(hour), minute: \(minute)")
        }
    }
    
}

extension RootInteractor {
    func request(_ request: AuthorizationRequestListenerRequest) {
        router?.request(.detachAuthorizationRequest)
        switch request {
        case .agree:
            print("agree")
        case .disagree:
            router?.request(.routeToAuthorizationDenied)
        }
    }
}

extension RootInteractor {
    func request(_ request: AuthorizationDeniedListenerRequest) {
        router?.request(.detachAuthorizationDenied)
        switch request {
        case .later:
            print("later")
        case .allowed:
            print("allowed")
        }
    }
}
