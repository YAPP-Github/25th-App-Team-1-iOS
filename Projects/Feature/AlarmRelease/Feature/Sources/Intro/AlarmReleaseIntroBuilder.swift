//
//  AlarmReleaseIntroBuilder.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/10/25.
//

import RIBs

protocol AlarmReleaseIntroDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AlarmReleaseIntroComponent: Component<AlarmReleaseIntroDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AlarmReleaseIntroBuildable: Buildable {
    func build(withListener listener: AlarmReleaseIntroListener) -> AlarmReleaseIntroRouting
}

final class AlarmReleaseIntroBuilder: Builder<AlarmReleaseIntroDependency>, AlarmReleaseIntroBuildable {

    override init(dependency: AlarmReleaseIntroDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AlarmReleaseIntroListener) -> AlarmReleaseIntroRouting {
        let component = AlarmReleaseIntroComponent(dependency: dependency)
        let viewController = AlarmReleaseIntroViewController()
        let interactor = AlarmReleaseIntroInteractor(presenter: viewController)
        interactor.listener = listener
        return AlarmReleaseIntroRouter(interactor: interactor, viewController: viewController)
    }
}
