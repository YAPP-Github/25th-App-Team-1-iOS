//
//  ShakeMissionMainBuilder.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 1/20/25.
//

import UIKit

import RIBs

public protocol ShakeMissionMainDependency: Dependency {}

final class ShakeMissionMainComponent: Component<ShakeMissionMainDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

public protocol ShakeMissionMainBuildable: Buildable {
    func build(withListener listener: ShakeMissionMainListener) -> ShakeMissionMainRouting
}

public final class ShakeMissionMainBuilder: Builder<ShakeMissionMainDependency>, ShakeMissionMainBuildable {

    public override init(dependency: ShakeMissionMainDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: ShakeMissionMainListener) -> ShakeMissionMainRouting {
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
