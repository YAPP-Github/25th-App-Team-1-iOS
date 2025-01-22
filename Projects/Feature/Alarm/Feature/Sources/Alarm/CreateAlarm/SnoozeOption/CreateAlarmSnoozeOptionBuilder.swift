//
//  CreateAlarmSnoozeOptionBuilder.swift
//  FeatureAlarm
//
//  Created by ever on 1/20/25.
//

import RIBs

protocol CreateAlarmSnoozeOptionDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class CreateAlarmSnoozeOptionComponent: Component<CreateAlarmSnoozeOptionDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol CreateAlarmSnoozeOptionBuildable: Buildable {
    func build(withListener listener: CreateAlarmSnoozeOptionListener) -> CreateAlarmSnoozeOptionRouting
}

final class CreateAlarmSnoozeOptionBuilder: Builder<CreateAlarmSnoozeOptionDependency>, CreateAlarmSnoozeOptionBuildable {

    override init(dependency: CreateAlarmSnoozeOptionDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CreateAlarmSnoozeOptionListener) -> CreateAlarmSnoozeOptionRouting {
        let component = CreateAlarmSnoozeOptionComponent(dependency: dependency)
        let viewController = CreateAlarmSnoozeOptionViewController()
        let interactor = CreateAlarmSnoozeOptionInteractor(presenter: viewController)
        interactor.listener = listener
        return CreateAlarmSnoozeOptionRouter(interactor: interactor, viewController: viewController)
    }
}
