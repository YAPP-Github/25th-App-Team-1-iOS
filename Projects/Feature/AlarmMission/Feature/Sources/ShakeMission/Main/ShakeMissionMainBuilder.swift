//
//  ShakeMissionMainBuilder.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 1/20/25.
//

import RIBs

protocol ShakeMissionMainDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ShakeMissionMainComponent: Component<ShakeMissionMainDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ShakeMissionMainBuildable: Buildable {
    func build(withListener listener: ShakeMissionMainListener) -> ShakeMissionMainRouting
}

final class ShakeMissionMainBuilder: Builder<ShakeMissionMainDependency>, ShakeMissionMainBuildable {

    override init(dependency: ShakeMissionMainDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ShakeMissionMainListener) -> ShakeMissionMainRouting {
        let component = ShakeMissionMainComponent(dependency: dependency)
        let viewController = ShakeMissionMainViewController()
        let interactor = ShakeMissionMainInteractor(presenter: viewController)
        interactor.listener = listener
        let shakeMissionWorkingBuilder = ShakeMissionWorkingBuilder(dependency: component)
        return ShakeMissionMainRouter(
            interactor: interactor,
            viewController: viewController,
            shakeMissionWorkingBuilder: shakeMissionWorkingBuilder
        )
    }
}
