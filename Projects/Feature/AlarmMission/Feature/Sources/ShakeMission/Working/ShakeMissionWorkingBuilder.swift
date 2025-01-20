//
//  ShakeMissionWorkingBuilder.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 1/20/25.
//

import RIBs

protocol ShakeMissionWorkingDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ShakeMissionWorkingComponent: Component<ShakeMissionWorkingDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ShakeMissionWorkingBuildable: Buildable {
    func build(withListener listener: ShakeMissionWorkingListener) -> ShakeMissionWorkingRouting
}

final class ShakeMissionWorkingBuilder: Builder<ShakeMissionWorkingDependency>, ShakeMissionWorkingBuildable {

    override init(dependency: ShakeMissionWorkingDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ShakeMissionWorkingListener) -> ShakeMissionWorkingRouting {
        let component = ShakeMissionWorkingComponent(dependency: dependency)
        let viewController = ShakeMissionWorkingViewController()
        let interactor = ShakeMissionWorkingInteractor(presenter: viewController)
        interactor.listener = listener
        return ShakeMissionWorkingRouter(interactor: interactor, viewController: viewController)
    }
}
