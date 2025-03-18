//
//  RootBuilder.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import FeatureLogger

import RIBs

public enum EntryPoint {
    case intro
    case inputName
    case inputBornTime
    case inputGender
    case inputWakeUpAlarm
    case inputBirthDate
    case authorizationRequest
}

public protocol RootDependency: Dependency {
    var onboardingRootViewController: RootViewControllable { get }
    var logger: Logger { get }
}

final class RootComponent: Component<RootDependency> {
    fileprivate var rootViewController: RootViewControllable {
        return dependency.onboardingRootViewController
    }
    var logger: Logger { dependency.logger }
}

// MARK: - Builder

public protocol RootBuildable: Buildable {
    func build(withListener listener: RootListener, entryPoint: EntryPoint) -> RootRouting
}

public final class RootBuilder: Builder<RootDependency>, RootBuildable {

    public override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: RootListener, entryPoint: EntryPoint) -> RootRouting {
        let component = RootComponent(dependency: dependency)
        let interactor = RootInteractor(entryPoint: entryPoint, logger: dependency.logger)
        interactor.listener = listener
        let introBuilder = OnboardingIntroBuilder(dependency: component)
        let inputWakeUpAlarmBuilder = InputWakeUpAlarmBuilder(dependency: component)
        let inputBirthDateBuilder = InputBirthDateBuilder(dependency: component)
        let inputBornTimeBuilder = InputBornTimeBuilder(dependency: component)
        let inputNameBuilder = InputNameBuilder(dependency: component)
        let inputGenderBuilder = InputGenderBuilder(dependency: component)
        let authorizationRequestBuilder = AuthorizationRequestBuilder(dependency: component)
        let authorizationDeniedBuilder = AuthorizationDeniedBuilder(dependency: component)
        let onboardingMissionGuideBuilder = OnboardingMissionGuideBuilder(dependency: component)
        let onboardingFortuneGuideBuilder = OnboardingFortuneGuideBuilder(dependency: component)
        let inputSummaryBuilder = InputSummaryBuilder(dependency: component)
        
        return RootRouter(
            interactor: interactor,
            viewController: component.rootViewController,
            introBuilder: introBuilder,
            inputWakeUpAlarmBuilder: inputWakeUpAlarmBuilder,
            inputBirthDateBuilder: inputBirthDateBuilder,
            inputBornTimeBuilder: inputBornTimeBuilder,
            inputNameBuilder: inputNameBuilder,
            inputGenderBuilder: inputGenderBuilder,
            authorizationRequestBuilder: authorizationRequestBuilder,
            authorizationDeniedBuilder: authorizationDeniedBuilder,
            onboardingMissionGuideBuilder: onboardingMissionGuideBuilder,
            onboardingFortuneGuideBuilder: onboardingFortuneGuideBuilder,
            inputSummaryBuilder: inputSummaryBuilder
        )
    }
}
