//
//  CreateEditAlarmSnoozeOptionBuilder.swift
//  FeatureAlarm
//
//  Created by ever on 1/20/25.
//

import RIBs
import FeatureCommonDependencies

protocol CreateEditAlarmSnoozeOptionDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class CreateEditAlarmSnoozeOptionComponent: Component<CreateEditAlarmSnoozeOptionDependency> {
    fileprivate let snoozeOption: SnoozeOption
    
    init(dependency: CreateEditAlarmSnoozeOptionDependency, snoozeOption: SnoozeOption) {
        self.snoozeOption = snoozeOption
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol CreateEditAlarmSnoozeOptionBuildable: Buildable {
    func build(withListener listener: CreateEditAlarmSnoozeOptionListener, snoozeOption: SnoozeOption) -> CreateEditAlarmSnoozeOptionRouting
}

final class CreateEditAlarmSnoozeOptionBuilder: Builder<CreateEditAlarmSnoozeOptionDependency>, CreateEditAlarmSnoozeOptionBuildable {
    
    override init(dependency: CreateEditAlarmSnoozeOptionDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: CreateEditAlarmSnoozeOptionListener, snoozeOption: SnoozeOption) -> CreateEditAlarmSnoozeOptionRouting {
            let component = CreateEditAlarmSnoozeOptionComponent(dependency: dependency, snoozeOption: snoozeOption)
            let viewController = CreateEditAlarmSnoozeOptionViewController()
            let interactor = CreateEditAlarmSnoozeOptionInteractor(presenter: viewController, snoozeOption: snoozeOption)
            interactor.listener = listener
            return CreateEditAlarmSnoozeOptionRouter(interactor: interactor, viewController: viewController)
        }
}
