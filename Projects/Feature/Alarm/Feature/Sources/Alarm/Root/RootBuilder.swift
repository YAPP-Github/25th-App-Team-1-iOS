//
//  RootBuilder.swift
//  FeatureAlarm
//
//  Created by ever on 1/1/25.
//

import RIBs

public protocol RootDependency: Dependency {
    // TODO: Make sure to convert the variable into lower-camelcase.
    var alarmRootViewController: RootViewControllable { get }
    // TODO: Declare the set of dependencies required by this RIB, but won't be
    // created by this RIB.
}

final class RootComponent: Component<RootDependency> {
    fileprivate var RootViewController: RootViewControllable {
        return dependency.alarmRootViewController
    }
    fileprivate var service: RootServiceable
    
    var alarmListMutableStream: AlarmListMutableStream {
        return shared { MutableAlarmListStreamImpl() }
    }
    
    var createAlarmMutableStream: CreateAlarmMutableStream {
        return shared { CreateAlarmMutableStreamImpl() }
    }
    
    init(dependency: any RootDependency,
         service: RootServiceable = RootService()
    ) {
        self.service = service
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol RootBuildable: Buildable {
    func build(withListener listener: RootListener) -> RootRouting
}

public final class RootBuilder: Builder<RootDependency>, RootBuildable {

    public override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: RootListener) -> RootRouting {
        let component = RootComponent(dependency: dependency)
        let interactor = RootInteractor(
            service: component.service,
            alarmListMutableStream: component.alarmListMutableStream,
            createAlarmMutableStream: component.createAlarmMutableStream
        )
        interactor.listener = listener
        let alarmListBuilder = AlarmListBuilder(dependency: component)
        let createAlarmBuilder = CreateAlarmBuilder(dependency: component)
        let snoozeOptionBuilder = CreateAlarmSnoozeOptionBuilder(dependency: component)
        let soundOptionBuilder = CreateAlarmSoundOptionBuilder(dependency: component)
        
        return RootRouter(
            interactor: interactor,
            viewController: component.RootViewController,
            alarmListBuilder: alarmListBuilder,
            createAlarmBuilder: createAlarmBuilder,
            snoozeOptionBuilder: snoozeOptionBuilder,
            soundOptionBuilder: soundOptionBuilder
        )
    }
}
