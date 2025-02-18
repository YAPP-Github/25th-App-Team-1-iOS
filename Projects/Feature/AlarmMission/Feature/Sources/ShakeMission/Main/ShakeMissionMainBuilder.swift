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
    fileprivate let isFirstAlarm: Bool
    init(dependency: ShakeMissionMainDependency, isFirstAlarm: Bool) {
        self.isFirstAlarm = isFirstAlarm
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol ShakeMissionMainBuildable: Buildable {
    func build(withListener listener: ShakeMissionMainListener, isFirstAlarm: Bool) -> ShakeMissionMainRouting
}

public final class ShakeMissionMainBuilder: Builder<ShakeMissionMainDependency>, ShakeMissionMainBuildable {

    public override init(dependency: ShakeMissionMainDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: ShakeMissionMainListener, isFirstAlarm: Bool) -> ShakeMissionMainRouting {
        let component = ShakeMissionMainComponent(dependency: dependency, isFirstAlarm: isFirstAlarm)
        let viewController = ShakeMissionMainViewController()
        let interactor = ShakeMissionMainInteractor(presenter: viewController, isFirstAlarm: isFirstAlarm)
        interactor.listener = listener
        let shakeMissionWorkingBuilder = ShakeMissionWorkingBuilder(dependency: component)
        return ShakeMissionMainRouter(
            interactor: interactor,
            viewController: viewController,
            shakeMissionWorkingBuilder: shakeMissionWorkingBuilder
        )
    }
}
