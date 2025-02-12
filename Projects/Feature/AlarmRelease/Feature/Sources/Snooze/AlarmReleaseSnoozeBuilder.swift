//
//  AlarmReleaseSnoozeBuilder.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/12/25.
//

import RIBs
import UIKit
import FeatureCommonDependencies

protocol AlarmReleaseSnoozeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AlarmReleaseSnoozeComponent: Component<AlarmReleaseSnoozeDependency> {
    fileprivate let snoozeOption: SnoozeOption
    
    init(dependency: AlarmReleaseSnoozeDependency, snoozeOption: SnoozeOption) {
        self.snoozeOption = snoozeOption
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol AlarmReleaseSnoozeBuildable: Buildable {
    func build(withListener listener: AlarmReleaseSnoozeListener, snoozeOption: SnoozeOption) -> AlarmReleaseSnoozeRouting
}

final class AlarmReleaseSnoozeBuilder: Builder<AlarmReleaseSnoozeDependency>, AlarmReleaseSnoozeBuildable {

    override init(dependency: AlarmReleaseSnoozeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AlarmReleaseSnoozeListener, snoozeOption: SnoozeOption) -> AlarmReleaseSnoozeRouting {
        let component = AlarmReleaseSnoozeComponent(dependency: dependency, snoozeOption: snoozeOption)
        let viewController = AlarmReleaseSnoozeViewController()
        let interactor = AlarmReleaseSnoozeInteractor(presenter: viewController, snoozeOption: component.snoozeOption)
        interactor.listener = listener
        return AlarmReleaseSnoozeRouter(interactor: interactor, viewController: viewController)
    }
}
