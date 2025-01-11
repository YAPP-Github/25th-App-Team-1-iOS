//
//  RootBuilder.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

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
    // TODO: Make sure to convert the variable into lower-camelcase.
    var rootViewController: RootViewControllable { get }
    // TODO: Declare the set of dependencies required by this RIB, but won't be
    // created by this RIB.
}

final class RootComponent: Component<RootDependency> {

    // TODO: Make sure to convert the variable into lower-camelcase.
    fileprivate var rootViewController: RootViewControllable {
        return dependency.rootViewController
    }

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
        let interactor = RootInteractor(entryPoint: entryPoint)
        interactor.listener = listener
        let introBuilder = IntroBuilder(dependency: component)
        let inputNameBuilder = InputNameBuilder(dependency: component)
        let inputBornTimeBuilder = InputBornTimeBuilder(dependency: component)
        let inputGenderBuilder = InputGenderBuilder(dependency: component)
        let inputWakeUpAlarmBuilder = InputWakeUpAlarmBuilder(dependency: component)
        let inputBirthDateBuilder = InputBirthDateBuilder(dependency: component)
        let authorizationRequestBuilder = AuthorizationRequestBuilder(dependency: component)
        
        return RootRouter(
            interactor: interactor,
            viewController: component.rootViewController,
            introBuilder: introBuilder,
            inputNameBuilder: inputNameBuilder,
            inputBornTimeBuilder: inputBornTimeBuilder,
            inputGenderBuilder: inputGenderBuilder,
            inputWakeUpAlarmBuilder: inputWakeUpAlarmBuilder,
            inputBirthDateBuilder: inputBirthDateBuilder,
            authorizationRequestBuilder: authorizationRequestBuilder
        )
    }
}
