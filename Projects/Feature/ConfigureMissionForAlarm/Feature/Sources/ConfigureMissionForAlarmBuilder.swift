//
//  ConfigureMissionForAlarmBuilder.swift
//  FeatureConfigureMissionForAlarm
//
//  Created by choijunios on 7/21/25.
//

import RIBs
import FeatureCommonEntity
import FeatureAlarmMission
import FeatureLogger

public protocol ConfigureMissionForAlarmDependency: Dependency, AlarmMissionRootDependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ConfigureMissionForAlarmComponent: Component<ConfigureMissionForAlarmDependency>, AlarmMissionRootDependency {
    var logger: Logger { dependency.logger }
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
        let alarmMissionBuilder = AlarmMissionRootBuilder(dependency: component)
        return ConfigureMissionForAlarmRouter(
            interactor: interactor, 
            viewController: viewController,
            alarmMissionBuilder: alarmMissionBuilder
        )
    }
}
