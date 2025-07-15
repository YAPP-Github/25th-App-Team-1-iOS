//
//  RootBuilder.swift
//  FeatureAlarmRelease
//
//  Created by ever on 7/1/25.
//

import UIKit
import RIBs
import FeatureAlarmController
import FeatureCommonDependencies
import FeatureLogger
import FeatureAlarmMission
import FeatureFortune


public protocol RootDependency: Dependency {
    var presentingViewController: UIViewController { get }
    var alarmController: AlarmController { get }
    var logger: Logger { get }
}

final class RootComponent: Component<RootDependency> {
    fileprivate var presentingViewController: UIViewController {
        return dependency.presentingViewController
    }
    let alarm: Alarm
    let isFirstAlarm: Bool
    
    var releaseAlarmMutableStream: ReleaseAlarmMutableStream {
        return shared { ReleaseAlarmStreamImpl() }
    }
    
    init(dependency: RootDependency, alarm: Alarm, isFirstAlarm: Bool) {
        self.alarm = alarm
        self.isFirstAlarm = isFirstAlarm
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol RootBuildable: Buildable {
    func build(withListener listener: RootListener, alarm: Alarm, isFirstAlarm: Bool) -> RootRouting
}

public final class RootBuilder: Builder<RootDependency>, RootBuildable {

    public override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: RootListener, alarm: Alarm, isFirstAlarm: Bool) -> RootRouting {
        let component = RootComponent(dependency: dependency, alarm: alarm, isFirstAlarm: isFirstAlarm)
        let interactor = RootInteractor(
            alarm: alarm, 
            isFirstAlarm: isFirstAlarm,
            stream: component.releaseAlarmMutableStream,
            logger: dependency.logger
        )
        interactor.listener = listener
        
        let introBuilder = AlarmReleaseIntroBuilder(dependency: component)
        let snoozeBuilder = AlarmReleaseSnoozeBuilder(dependency: component)
        let missionBuilder = AlarmMissionRootBuilder(dependency: component)
        let fortuneBuilder = FortuneBuilder(dependency: component)
        return RootRouter(
            interactor: interactor,
            presentingViewController: component.presentingViewController,
            introBuilder: introBuilder,
            snoozeBuilder: snoozeBuilder,
            missionBuilder: missionBuilder,
            fortuneBuilder: fortuneBuilder
        )
    }
}
