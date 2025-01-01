//
//  RootBuilder.swift
//  FeatureAlarm
//
//  Created by ever on 1/1/25.
//

import RIBs

protocol RootDependency: Dependency {
    // TODO: Make sure to convert the variable into lower-camelcase.
    var RootViewController: RootViewControllable { get }
    // TODO: Declare the set of dependencies required by this RIB, but won't be
    // created by this RIB.
}

final class RootComponent: Component<RootDependency> {

    // TODO: Make sure to convert the variable into lower-camelcase.
    fileprivate var RootViewController: RootViewControllable {
        return dependency.RootViewController
    }

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RootBuildable: Buildable {
    func build(withListener listener: RootListener) -> RootRouting
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {

    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RootListener) -> RootRouting {
        let component = RootComponent(dependency: dependency)
        let interactor = RootInteractor()
        interactor.listener = listener
        let alarmListBuilder = AlarmListBuilder(dependency: component)
        let createAlarmBuilder = CreateAlarmBuilder(dependency: component)
        return RootRouter(
            interactor: interactor,
            viewController: component.RootViewController,
            alarmListBuilder: alarmListBuilder,
            createAlarmBuilder: createAlarmBuilder
        )
    }
}
