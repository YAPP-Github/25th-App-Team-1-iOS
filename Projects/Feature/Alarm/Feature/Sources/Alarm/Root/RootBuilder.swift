//
//  RootBuilder.swift
//  FeatureAlarm
//
//  Created by ever on 1/1/25.
//

import FeatureLogger

import RIBs

public protocol RootDependency: Dependency {
    var alarmRootViewController: RootViewControllable { get }
    var logger: Logger { get }
}

final class RootComponent: Component<RootDependency> {
    fileprivate let rootViewController: RootViewControllable
    fileprivate var service: RootServiceable
    fileprivate var mode: AlarmCreateEditMode
    
    var alarmListMutableStream: AlarmListMutableStream {
        return shared { MutableAlarmListStreamImpl() }
    }
    
    var createAlarmMutableStream: CreateEditAlarmMutableStream {
        return shared { CreateEditAlarmMutableStreamImpl() }
    }
    
    var logger: Logger { dependency.logger }
    
    init(dependency: any RootDependency,
         viewController: RootViewControllable,
         service: RootServiceable = RootService(),
         mode: AlarmCreateEditMode
    ) {
        self.service = service
        self.mode = mode
        self.rootViewController = viewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol RootBuildable: Buildable {
    func build(withListener listener: RootListener, mode: AlarmCreateEditMode) -> RootRouting
}

public final class RootBuilder: Builder<RootDependency>, RootBuildable {

    public override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: RootListener, mode: AlarmCreateEditMode) -> RootRouting {
        let component = RootComponent(dependency: dependency, viewController: dependency.alarmRootViewController, mode: mode)
        let interactor = RootInteractor(
            service: component.service,
            mode: component.mode,
            alarmListMutableStream: component.alarmListMutableStream,
            createAlarmMutableStream: component.createAlarmMutableStream
        )
        interactor.listener = listener
        let createAlarmBuilder = CreateEditAlarmBuilder(dependency: component)
        let snoozeOptionBuilder = CreateEditAlarmSnoozeOptionBuilder(dependency: component)
        let soundOptionBuilder = CreateEditAlarmSoundOptionBuilder(dependency: component)
        
        return RootRouter(
            interactor: interactor,
            viewController: component.rootViewController,
            createAlarmBuilder: createAlarmBuilder,
            snoozeOptionBuilder: snoozeOptionBuilder,
            soundOptionBuilder: soundOptionBuilder
        )
    }
}
