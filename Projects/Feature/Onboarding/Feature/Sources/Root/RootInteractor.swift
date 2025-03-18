//
//  RootInteractor.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import UIKit

import FeatureCommonDependencies
import FeatureNetworking
import FeatureLogger

import RIBs
import RxSwift

public enum RootRouterRequest {
    case cleanUpViews
    case routeToIntro
    case routeToInputWakeUpAlarm(OnboardingModel)
    case detachInputWakeUpAlarm
    case routeToInputBirthDate(OnboardingModel)
    case detachInputBirthDate
    case routeToInputBornTime(OnboardingModel)
    case detachInputBornTime
    case routeToInputName(OnboardingModel)
    case detachInputName
    case routeToInputGender(OnboardingModel)
    case detachInputGender
    case routeToAuthorizationRequest
    case detachAuthorizationRequest
    case routeToAuthorizationDenied
    case routeToMissionGuide
    case detachMissionGuide
    case routeToFortuneGuide
    case detachFortuneGuide
    case routeToInputSummary(OnboardingModel)
    case detachInputSummary(completion: (() -> Void)?)
}

public protocol RootRouting: Routing {
    func request(_ request: RootRouterRequest)
}

public enum RootListenerRequest {
    case start(Alarm)
}

public protocol RootListener: AnyObject {
    func request(_ request: RootListenerRequest)
}

final class RootInteractor: Interactor, RootInteractable {
    // Dependecny
    private let logger: Logger
    

    weak var router: RootRouting?
    weak var listener: RootListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(entryPoint: EntryPoint, logger: Logger) {
        self.entryPoint = entryPoint
        self.logger = logger
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        switch entryPoint {
        case .intro:
            router?.request(.routeToIntro)
        case .inputName:
            router?.request(.routeToInputName(onboardingModel))
        case .inputBornTime:
            router?.request(.routeToInputBornTime(onboardingModel))
        case .inputGender:
            router?.request(.routeToInputGender(onboardingModel))
        case .inputWakeUpAlarm:
            router?.request(.routeToInputWakeUpAlarm(onboardingModel))
        case .inputBirthDate:
            router?.request(.routeToInputBirthDate(onboardingModel))
        case .authorizationRequest:
            router?.request(.routeToAuthorizationRequest)
        }
    }

    override func willResignActive() {
        super.willResignActive()

        router?.request(.cleanUpViews)
    }
    
    private let entryPoint: EntryPoint
    private var onboardingModel = OnboardingModel()
}


// MARK: OnboardingIntroListenerRequest
extension RootInteractor {
    func request(_ request: OnboardingIntroListenerRequest) {
        switch request {
        case .next:
            router?.request(.routeToInputWakeUpAlarm(onboardingModel))
        }
    }
}


// MARK: InputWakeUpAlarmListenerRequest
extension RootInteractor {
    func request(_ request: InputWakeUpAlarmListenerRequest) {
        switch request {
        case .back:
            router?.request(.detachInputWakeUpAlarm)
        case let .next(model):
            onboardingModel.alarm = model.alarm
            router?.request(.routeToInputBirthDate(onboardingModel))
        }
    }
}


// MARK: InputBirthDateListenerRequest
extension RootInteractor {
    func request(_ request: InputBirthDateListenerRequest) {
        switch request {
        case .back:
            router?.request(.detachInputBirthDate)
        case let .confirmBirthDate(model):
            onboardingModel.birthDate = model.birthDate
            router?.request(.routeToInputBornTime(onboardingModel))
        }
    }
}


// MARK: InputBornTimeListenerRequest
extension RootInteractor {
    func request(_ request: InputBornTimeListenerRequest) {
        switch request {
        case .back:
            router?.request(.detachInputBornTime)
        case let .next(model):
            onboardingModel.bornTime = model.bornTime
            router?.request(.routeToInputName(onboardingModel))
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
            router?.request(.detachInputName)
        case let .next(model):
            onboardingModel.name = model.name
            router?.request(.routeToInputGender(onboardingModel))
        }
    }
}


// MARK: InputGenderListenerRequest
extension RootInteractor {
    func request(_ request: InputGenderListenerRequest) {
        switch request {
        case .back:
            router?.request(.detachInputGender)
        case let .next(model):
            onboardingModel.gender = model.gender
            router?.request(.routeToInputSummary(onboardingModel))
        }
    }
}


// MARK: AuthorizationDeniedListenerRequest
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
        case .back:
            router?.request(.detachMissionGuide)
        case .next:
            router?.request(.routeToFortuneGuide)
        }
    }
}


// MARK: OnboardingFortuneGuideListenerRequest
extension RootInteractor {
    func request(_ request: OnboardingFortuneGuideListenerRequest) {
        switch request {
        case .back:
            router?.request(.detachFortuneGuide)
        case .start:
            let onboardingModel = onboardingModel
            let request = APIRequest.Users.addUser(
                name: onboardingModel.name ?? "",
                birthDate: onboardingModel.birthDate.toDateString(),
                birthTime: onboardingModel.bornTime?.toTimeString(),
                gender: onboardingModel.gender?.rawValue ?? "",
                calendarType: onboardingModel.birthDate.calendarType.rawValue
            )
                
            APIClient.request(Int.self, request: request) { [weak self, weak listener] userId in
                guard let self, let listener else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    // 유저 아이디 저장
                    Preference.userId = userId
                    // - 로깅 정보 업데이트
                    logger.setupUser(id: String(userId))
                    
                    // 유저정보 저장
                    Preference.userInfo = .init(
                        id: userId,
                        name: onboardingModel.name!,
                        birthDate: onboardingModel.birthDate,
                        birthTime: onboardingModel.bornTime,
                        gender: onboardingModel.gender!
                    )
                    listener.request(.start(onboardingModel.alarm))
                }
            } failure: { error in
                print("Error: \(error)")
            }
            
        }
    }
}


// MARK: InputSummaryListener
extension RootInteractor {
    func request(_ request: InputSummaryListenerRequest) {
        switch request {
        case .dismiss:
            router?.request(.detachInputSummary(completion: nil))
        case .next:
            router?.request(.detachInputSummary { [weak self] in
                self?.router?.request(.routeToAuthorizationRequest)
            })
            
        }
    }
}
