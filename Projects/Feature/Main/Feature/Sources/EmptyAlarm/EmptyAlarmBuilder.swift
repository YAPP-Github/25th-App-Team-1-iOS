//
//  EmptyAlarmBuilder.swift
//  FeatureMain
//
//  Created by ever on 2/7/25.
//

import RIBs

protocol EmptyAlarmDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class EmptyAlarmComponent: Component<EmptyAlarmDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol EmptyAlarmBuildable: Buildable {
    func build(withListener listener: EmptyAlarmListener) -> EmptyAlarmRouting
}

final class EmptyAlarmBuilder: Builder<EmptyAlarmDependency>, EmptyAlarmBuildable {

    override init(dependency: EmptyAlarmDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: EmptyAlarmListener) -> EmptyAlarmRouting {
        let component = EmptyAlarmComponent(dependency: dependency)
        let viewController = EmptyAlarmViewController()
        let interactor = EmptyAlarmInteractor(presenter: viewController)
        interactor.listener = listener
        return EmptyAlarmRouter(interactor: interactor, viewController: viewController)
    }
}
