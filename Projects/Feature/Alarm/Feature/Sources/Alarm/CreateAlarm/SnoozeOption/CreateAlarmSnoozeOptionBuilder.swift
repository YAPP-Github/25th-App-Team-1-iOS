//
//  CreateAlarmSnoozeOptionBuilder.swift
//  FeatureAlarm
//
//  Created by ever on 1/20/25.
//

import RIBs
import FeatureCommonDependencies

protocol CreateAlarmSnoozeOptionDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class CreateAlarmSnoozeOptionComponent: Component<CreateAlarmSnoozeOptionDependency> {
    fileprivate let snoozeOption: SnoozeOption
    
    init(dependency: CreateAlarmSnoozeOptionDependency, snoozeOption: SnoozeOption) {
        self.snoozeOption = snoozeOption
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol CreateAlarmSnoozeOptionBuildable: Buildable {
    func build(withListener listener: CreateAlarmSnoozeOptionListener, snoozeOption: SnoozeOption) -> CreateAlarmSnoozeOptionRouting
}

final class CreateAlarmSnoozeOptionBuilder: Builder<CreateAlarmSnoozeOptionDependency>, CreateAlarmSnoozeOptionBuildable {
    
    override init(dependency: CreateAlarmSnoozeOptionDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: CreateAlarmSnoozeOptionListener, snoozeOption: SnoozeOption) -> CreateAlarmSnoozeOptionRouting {
            let component = CreateAlarmSnoozeOptionComponent(dependency: dependency, snoozeOption: snoozeOption)
            let viewController = CreateAlarmSnoozeOptionViewController()
            let interactor = CreateAlarmSnoozeOptionInteractor(presenter: viewController, snoozeOption: snoozeOption)
            interactor.listener = listener
            return CreateAlarmSnoozeOptionRouter(interactor: interactor, viewController: viewController)
        }
}
