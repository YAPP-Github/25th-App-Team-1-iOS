//
//  CreateAlarmBuilder.swift
//  FeatureAlarm
//
//  Created by ever on 12/30/24.
//

import RIBs
import FeatureCommonDependencies

public enum AlarmCreateEditMode {
    case create
    case edit(Alarm)
}

protocol CreateAlarmDependency: Dependency {
    var createAlarmStream: CreateAlarmStream { get }
}

final class CreateAlarmComponent: Component<CreateAlarmDependency> {
    fileprivate let mode: AlarmCreateEditMode
    fileprivate let createAlarmStream: CreateAlarmStream
    init(dependency: CreateAlarmDependency,
         mode: AlarmCreateEditMode
    ) {
        self.mode = mode
        self.createAlarmStream = dependency.createAlarmStream
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol CreateAlarmBuildable: Buildable {
    func build(withListener listener: CreateAlarmListener, mode: AlarmCreateEditMode) -> CreateAlarmRouting
}

final class CreateAlarmBuilder: Builder<CreateAlarmDependency>, CreateAlarmBuildable {

    override init(dependency: CreateAlarmDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CreateAlarmListener, mode: AlarmCreateEditMode) -> CreateAlarmRouting {
        let component = CreateAlarmComponent(dependency: dependency, mode: mode)
        let viewController = CreateAlarmViewController()
        let interactor = CreateAlarmInteractor(
            presenter: viewController,
            mode: component.mode,
            createAlarmStream: component.createAlarmStream
        )
        interactor.listener = listener
        return CreateAlarmRouter(interactor: interactor, viewController: viewController)
    }
}
