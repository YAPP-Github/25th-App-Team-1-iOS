//
//  MissionRootBuilder.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 3/4/25.
//

import UIKit

import RIBs
import RxRelay

public protocol AlarmMissionRootDependency: Dependency { }

final class AlarmMissionRootComponent: Component<AlarmMissionRootDependency> {
    
    internal let missionAction: PublishRelay<MissionState> = .init()
}

// MARK: - Builder

public protocol AlarmMissionRootBuildable: Buildable {
    func build(withListener listener: AlarmMissionRootListener, rootController: UIViewController, missionType: AlarmMissionType, isFirstAlarm: Bool) -> AlarmMissionRootRouting
}

public final class AlarmMissionRootBuilder: Builder<AlarmMissionRootDependency>, AlarmMissionRootBuildable {
    public override init(dependency: AlarmMissionRootDependency) {
        super.init(dependency: dependency)
    }

    public func build(
        withListener listener: AlarmMissionRootListener,
        rootController: UIViewController,
        missionType: AlarmMissionType,
        isFirstAlarm: Bool) -> AlarmMissionRootRouting {
        let component = AlarmMissionRootComponent(dependency: dependency)
        let interactor = AlarmMissionRootInteractor(
            missionType: missionType,
            isFirstAlarm: isFirstAlarm,
            missionAction: component.missionAction
        )
        interactor.listener = listener
        let shakeMissionBuilder = ShakeMissionMainBuilder(dependency: component)
        let tapMissionBuilder = TapMissionMainBuilder(dependency: component)
        return AlarmMissionRootRouter(
            interactor: interactor,
            viewController: rootController,
            shakeMissionBuilder: shakeMissionBuilder,
            tapMissionBuilder: tapMissionBuilder
        )
    }
}
