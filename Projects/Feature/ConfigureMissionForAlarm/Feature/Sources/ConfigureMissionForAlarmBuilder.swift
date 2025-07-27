//
//  ConfigureMissionForAlarmBuilder.swift
//  FeatureConfigureMissionForAlarm
//
//  Created by choijunios on 7/21/25.
//

import RIBs
import FeatureCommonEntity

public protocol ConfigureMissionForAlarmDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ConfigureMissionForAlarmComponent: Component<ConfigureMissionForAlarmDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

public protocol ConfigureMissionForAlarmBuildable: Buildable {
    func build(withListener listener: ConfigureMissionForAlarmListener, initialMission: Mission) -> ConfigureMissionForAlarmRouting
}

public final class ConfigureMissionForAlarmBuilder: Builder<ConfigureMissionForAlarmDependency>, ConfigureMissionForAlarmBuildable {

    public override init(dependency: ConfigureMissionForAlarmDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: ConfigureMissionForAlarmListener, initialMission: Mission) -> ConfigureMissionForAlarmRouting {
        let component = ConfigureMissionForAlarmComponent(dependency: dependency)
        let viewController = ConfigureMissionForAlarmViewController()
        let interactor = ConfigureMissionForAlarmInteractor(presenter: viewController, initialMission: initialMission)
        interactor.listener = listener
        return ConfigureMissionForAlarmRouter(interactor: interactor, viewController: viewController)
    }
}
