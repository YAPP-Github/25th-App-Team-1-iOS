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
    case routeToInputWakeUpAlarm
    case detachInputWakeUpAlarm
    case routeToInputBirthDate
    case detachInputBirthDate
    case routeToInputBornTime
    case detachInputBornTime
    case routeToInputName
    case detachInputName
    case routeToInputGender
    case detachInputGender
    case routeToAuthorizationRequest
    case detachAuthorizationRequest
    case routeToAuthorizationDenied
    case detachAuthorizationDenied
    case routeToMissionGuide
    case routeToFortuneGuide
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

// MARK: IntroListenerRequest
extension RootInteractor {
    func request(_ request: IntroListenerRequest) {
        switch request {
        case .next:
            router?.request(.routeToInputWakeUpAlarm)
        }
    }
}

// MARK: InputWakeUpAlarmListenerRequest
extension RootInteractor {
    func request(_ request: InputWakeUpAlarmListenerRequest) {
        switch request {
        case .back:
            onboardingModel.alarm = nil
            router?.request(.detachInputWakeUpAlarm)
        case let .next(alarmData):
            onboardingModel.alarm = alarmData
            router?.request(.routeToInputBirthDate)
        }
    }
}

// MARK: InputBirthDateListenerRequest
extension RootInteractor {
    func request(_ request: InputBirthDateListenerRequest) {
        switch request {
        case .back:
            onboardingModel.birthDate = nil
            router?.request(.detachInputBirthDate)
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
            router?.request(.routeToMissionGuide)
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
        switch request {
        case .later:
            router?.request(.routeToMissionGuide)
        case .allowed:
            router?.request(.routeToMissionGuide)
        }
    }
}

// MARK: OnboardingMissionGuideListenerRequest
extension RootInteractor {
    func request(_ request: OnboardingMissionGuideListenerRequest) {
        switch request {
        case .next:
            router?.request(.routeToFortuneGuide)
        }
    }
}

// MARK: OnboardingFortuneGuideListenerRequest
extension RootInteractor {
    func request(_ request: OnboardingFortuneGuideListenerRequest) {
        switch request {
        case .start:
            break
            //여기다가 이제 온보딩 때 입력한 데이터 저장 및 메인 화면 호출 이벤트를 리스너에게 전달해야함.
        }
    }
}
