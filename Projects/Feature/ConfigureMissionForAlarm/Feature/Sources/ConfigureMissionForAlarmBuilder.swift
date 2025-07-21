//
//  ConfigureMissionForAlarmBuilder.swift
//  FeatureConfigureMissionForAlarm
//
//  Created by choijunios on 7/21/25.
//

import RIBs

protocol ConfigureMissionForAlarmDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ConfigureMissionForAlarmComponent: Component<ConfigureMissionForAlarmDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ConfigureMissionForAlarmBuildable: Buildable {
    func build(withListener listener: ConfigureMissionForAlarmListener) -> ConfigureMissionForAlarmRouting
}

final class ConfigureMissionForAlarmBuilder: Builder<ConfigureMissionForAlarmDependency>, ConfigureMissionForAlarmBuildable {

    override init(dependency: ConfigureMissionForAlarmDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ConfigureMissionForAlarmListener) -> ConfigureMissionForAlarmRouting {
        let component = ConfigureMissionForAlarmComponent(dependency: dependency)
        let viewController = ConfigureMissionForAlarmViewController()
        let interactor = ConfigureMissionForAlarmInteractor(presenter: viewController)
        interactor.listener = listener
        return ConfigureMissionForAlarmRouter(interactor: interactor, viewController: viewController)
    }
}
