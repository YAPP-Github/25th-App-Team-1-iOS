//
//  AlarmReleaseSnoozeBuilder.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/12/25.
//

import RIBs

protocol AlarmReleaseSnoozeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AlarmReleaseSnoozeComponent: Component<AlarmReleaseSnoozeDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AlarmReleaseSnoozeBuildable: Buildable {
    func build(withListener listener: AlarmReleaseSnoozeListener) -> AlarmReleaseSnoozeRouting
}

final class AlarmReleaseSnoozeBuilder: Builder<AlarmReleaseSnoozeDependency>, AlarmReleaseSnoozeBuildable {

    override init(dependency: AlarmReleaseSnoozeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AlarmReleaseSnoozeListener) -> AlarmReleaseSnoozeRouting {
        let component = AlarmReleaseSnoozeComponent(dependency: dependency)
        let viewController = AlarmReleaseSnoozeViewController()
        let interactor = AlarmReleaseSnoozeInteractor(presenter: viewController)
        interactor.listener = listener
        return AlarmReleaseSnoozeRouter(interactor: interactor, viewController: viewController)
    }
}
