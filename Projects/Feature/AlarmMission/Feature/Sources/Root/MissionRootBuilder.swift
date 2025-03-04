//
//  MissionRootBuilder.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 3/4/25.
//

import UIKit

import RIBs
import RxRelay

public protocol MissionRootDependency: Dependency {
    // TODO: Make sure to convert the variable into lower-camelcase.
    var rootViewController: UIViewController { get }
    // TODO: Declare the set of dependencies required by this RIB, but won't be
    // created by this RIB.
}

final class MissionRootComponent: Component<MissionRootDependency> {
    
    internal let missionAction: PublishRelay<MissionState> = .init()
    
    fileprivate var rootViewController: UIViewController {
        return dependency.rootViewController
    }
}

// MARK: - Builder

protocol MissionRootBuildable: Buildable {
    func build(withListener listener: MissionRootListener, mission: Mission, isFirstAlarm: Bool) -> MissionRootRouting
}

public final class MissionRootBuilder: Builder<MissionRootDependency>, MissionRootBuildable {
    public override init(dependency: MissionRootDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: MissionRootListener, mission: Mission, isFirstAlarm: Bool) -> MissionRootRouting {
        let component = MissionRootComponent(dependency: dependency)
        let interactor = MissionRootInteractor(
            mission: mission,
            isFirstAlarm: isFirstAlarm,
            missionAction: component.missionAction
        )
        interactor.listener = listener
        let shakeMissionBuilder = ShakeMissionMainBuilder(dependency: component)
        let tapMissionBuilder = TapMissionMainBuilder(dependency: component)
        return MissionRootRouter(
            interactor: interactor,
            viewController: component.rootViewController,
            shakeMissionBuilder: shakeMissionBuilder,
            tapMissionBuilder: tapMissionBuilder
        )
    }
}
