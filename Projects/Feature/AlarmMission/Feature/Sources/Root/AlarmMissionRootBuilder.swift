//
//  MissionRootBuilder.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 3/4/25.
//

import UIKit

import FeatureLogger

import RIBs
import RxRelay

public protocol AlarmMissionRootDependency: Dependency {
    var logger: Logger { get }
}

final class AlarmMissionRootComponent: Component<AlarmMissionRootDependency> {
    var action: PublishRelay<MissionState> { self.missionAction }
    var logger: Logger { dependency.logger }
    
    internal let missionAction: PublishRelay<MissionState> = .init()
}

// MARK: - Builder

public protocol AlarmMissionRootBuildable: Buildable {
    func build(withListener listener: AlarmMissionRootListener, navigationController: UINavigationController, missionType: AlarmMissionType) -> AlarmMissionRootRouting
}

public final class AlarmMissionRootBuilder: Builder<AlarmMissionRootDependency>, AlarmMissionRootBuildable {
    public override init(dependency: AlarmMissionRootDependency) {
        super.init(dependency: dependency)
    }

    public func build(
        withListener listener: AlarmMissionRootListener,
        navigationController: UINavigationController,
        missionType: AlarmMissionType
    ) -> AlarmMissionRootRouting {
        let component = AlarmMissionRootComponent(dependency: dependency)
        let interactor = AlarmMissionRootInteractor(
            missionType: missionType,
            missionAction: component.missionAction
        )
        interactor.listener = listener
        let shakeMissionBuilder = ShakeMissionWorkingBuilder(dependency: component)
        let tapMissionBuilder = TapMissionWorkingBuilder(dependency: component)
        return AlarmMissionRootRouter(
            interactor: interactor,
            viewController: navigationController,
            shakeMissionBuilder: shakeMissionBuilder,
            tapMissionBuilder: tapMissionBuilder
        )
    }
}
