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
    fileprivate var snoozeFrequency: SnoozeFrequency?
    fileprivate var snoozeCount: SnoozeCount?
    
    init(dependency: CreateAlarmSnoozeOptionDependency, snoozeFrequency: SnoozeFrequency?, snoozeCount: SnoozeCount?) {
        self.snoozeFrequency = snoozeFrequency
        self.snoozeCount = snoozeCount
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol CreateAlarmSnoozeOptionBuildable: Buildable {
    func build(
        withListener listener: CreateAlarmSnoozeOptionListener,
        snoozeFrequency: SnoozeFrequency?,
        snoozeCount: SnoozeCount?
    ) -> CreateAlarmSnoozeOptionRouting
}

final class CreateAlarmSnoozeOptionBuilder: Builder<CreateAlarmSnoozeOptionDependency>, CreateAlarmSnoozeOptionBuildable {

    override init(dependency: CreateAlarmSnoozeOptionDependency) {
        super.init(dependency: dependency)
    }

    func build(
        withListener listener: CreateAlarmSnoozeOptionListener,
        snoozeFrequency: SnoozeFrequency?,
        snoozeCount: SnoozeCount?
    ) -> CreateAlarmSnoozeOptionRouting {
        let component = CreateAlarmSnoozeOptionComponent(
            dependency: dependency,
            snoozeFrequency: snoozeFrequency,
            snoozeCount: snoozeCount
        )
        let viewController = CreateAlarmSnoozeOptionViewController()
        let interactor = CreateAlarmSnoozeOptionInteractor(
            presenter: viewController,
            snoozeFrequency: component.snoozeFrequency,
            snoozeCount: component.snoozeCount
        )
        interactor.listener = listener
        return CreateAlarmSnoozeOptionRouter(interactor: interactor, viewController: viewController)
    }
}
