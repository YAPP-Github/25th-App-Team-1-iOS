//
//  AlarmReleaseIntroBuilder.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/10/25.
//

import RIBs
import FeatureCommonDependencies

protocol AlarmReleaseIntroDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AlarmReleaseIntroComponent: Component<AlarmReleaseIntroDependency> {
    fileprivate let alarm: Alarm
    
    init(dependency: AlarmReleaseIntroDependency, alarm: Alarm) {
        self.alarm = alarm
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol AlarmReleaseIntroBuildable: Buildable {
    func build(withListener listener: AlarmReleaseIntroListener, alarm: Alarm) -> AlarmReleaseIntroRouting
}

final class AlarmReleaseIntroBuilder: Builder<AlarmReleaseIntroDependency>, AlarmReleaseIntroBuildable {

    override init(dependency: AlarmReleaseIntroDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AlarmReleaseIntroListener, alarm: Alarm) -> AlarmReleaseIntroRouting {
        let component = AlarmReleaseIntroComponent(dependency: dependency, alarm: alarm)
        let viewController = AlarmReleaseIntroViewController()
        let interactor = AlarmReleaseIntroInteractor(presenter: viewController, alarm: component.alarm)
        interactor.listener = listener
        return AlarmReleaseIntroRouter(interactor: interactor, viewController: viewController)
    }
}
