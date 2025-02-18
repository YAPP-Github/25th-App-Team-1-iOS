//
//  AlarmReleaseIntroBuilder.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/10/25.
//

import RIBs
import UIKit
import FeatureCommonDependencies

public protocol AlarmReleaseIntroDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AlarmReleaseIntroComponent: Component<AlarmReleaseIntroDependency> {
    fileprivate let alarm: Alarm
    fileprivate let isFirstAlarm: Bool
    
    init(dependency: AlarmReleaseIntroDependency, alarm: Alarm, isFirstAlarm: Bool) {
        self.alarm = alarm
        self.isFirstAlarm = isFirstAlarm
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol AlarmReleaseIntroBuildable: Buildable {
    func build(withListener listener: AlarmReleaseIntroListener, alarm: Alarm, isFirstAlarm: Bool) -> AlarmReleaseIntroRouting
}

public final class AlarmReleaseIntroBuilder: Builder<AlarmReleaseIntroDependency>, AlarmReleaseIntroBuildable {

    public override init(dependency: AlarmReleaseIntroDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: AlarmReleaseIntroListener, alarm: Alarm, isFirstAlarm: Bool) -> AlarmReleaseIntroRouting {
        let component = AlarmReleaseIntroComponent(dependency: dependency, alarm: alarm, isFirstAlarm: isFirstAlarm)
        let viewController = AlarmReleaseIntroViewController()
        let interactor = AlarmReleaseIntroInteractor(presenter: viewController, alarm: component.alarm, isFirstAlarm: isFirstAlarm)
        interactor.listener = listener
        
        let snoozeBuilder = AlarmReleaseSnoozeBuilder(dependency: component)
        return AlarmReleaseIntroRouter(
            interactor: interactor,
            viewController: viewController,
            snoozeBuilder: snoozeBuilder
        )
    }
}
