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
    case routeToInputBirthDate
    case routeToInputBornTime
    case detachInputBornTime
    case routeToInputName
    case detachInputName
    case routeToInputGender
    case detachInputGender
    case routeToInputWakeUpAlarm
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
    private var onboardingModel = OnboardingModel()
}

// MARK: InputBirthDateListenerRequest
extension RootInteractor {
    func request(_ request: InputBirthDateListenerRequest) {
        switch request {
        case let .confirmBirthDate(birthDateData):
            onboardingModel.birthDate = birthDateData
            router?.request(.routeToInputBornTime)
        }
    }
}

// MARK: InputBornTimeListenerRequest
extension RootInteractor {
    func request(_ request: InputBornTimeListenerRequest) {
        switch request {
        case .back:
            router?.request(.detachInputBornTime)
        case .skip:
            router?.request(.routeToInputName)
        case let .next(bornTimeData):
            onboardingModel.bornTime = bornTimeData
            router?.request(.routeToInputName)
        }
    }
    
}

// MARK: AuthorizationRequestListenerRequest
extension RootInteractor {
    func request(_ request: AuthorizationRequestListenerRequest) {
        switch request {
        case .back:
            router?.request(.detachAuthorizationRequest)
        case .agree:
            print("agree")
        case .disagree:
            router?.request(.routeToAuthorizationDenied)
        }
    }
}

// MARK: InputNameListenerRequest
extension RootInteractor {
    func request(_ request: InputNameListenerRequest) {
        switch request {
        case .back:
            onboardingModel.name = nil
            router?.request(.detachInputName)
        case let .next(name):
            onboardingModel.name = name
            router?.request(.routeToInputGender)
        }
    }
}

extension RootInteractor {
    func request(_ request: InputGenderListenerRequest) {
        switch request {
        case .back:
            onboardingModel.gender = nil
            router?.request(.detachInputGender)
        case let .next(gender):
            onboardingModel.gender = gender
            router?.request(.routeToAuthorizationRequest)
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
