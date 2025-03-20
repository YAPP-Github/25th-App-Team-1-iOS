//
//  ShakeMissionMainBuilder.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 1/20/25.
//

import UIKit

import FeatureLogger

import RIBs
import RxRelay

protocol ShakeMissionMainDependency: Dependency {
    var action: PublishRelay<MissionState> { get }
    var logger: Logger { get }
}

final class ShakeMissionMainComponent: Component<ShakeMissionMainDependency> {
    fileprivate let isFirstAlarm: Bool
    var logger: Logger { dependency.logger }
    init(dependency: ShakeMissionMainDependency, isFirstAlarm: Bool) {
        self.isFirstAlarm = isFirstAlarm
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol ShakeMissionMainBuildable: Buildable {
    func build(withListener listener: ShakeMissionMainListener, isFirstAlarm: Bool) -> ShakeMissionMainRouting
}

final class ShakeMissionMainBuilder: Builder<ShakeMissionMainDependency>, ShakeMissionMainBuildable {

    override init(dependency: ShakeMissionMainDependency) {
        super.init(dependency: dependency)
    }

    func build(
        withListener listener: ShakeMissionMainListener,
        isFirstAlarm: Bool
    ) -> ShakeMissionMainRouting {
        let component = ShakeMissionMainComponent(dependency: dependency, isFirstAlarm: isFirstAlarm)
        let viewController = ShakeMissionMainViewController()
        let interactor = ShakeMissionMainInteractor(
            presenter: viewController,
            missionAction: dependency.action,
            logger: dependency.logger
        )
        interactor.listener = listener
        let shakeMissionWorkingBuilder = ShakeMissionWorkingBuilder(dependency: component)
        return ShakeMissionMainRouter(
            interactor: interactor,
            viewController: viewController,
            shakeMissionWorkingBuilder: shakeMissionWorkingBuilder
        )
    }
}
