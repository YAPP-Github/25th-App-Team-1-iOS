//
//  CreateEditAlarmBuilder.swift
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

protocol CreateEditAlarmDependency: Dependency {
    var createAlarmStream: CreateEditAlarmStream { get }
}

final class CreateEditAlarmComponent: Component<CreateEditAlarmDependency> {
    fileprivate let mode: AlarmCreateEditMode
    fileprivate let createAlarmStream: CreateEditAlarmStream
    init(dependency: CreateEditAlarmDependency,
         mode: AlarmCreateEditMode
    ) {
        self.mode = mode
        self.createAlarmStream = dependency.createAlarmStream
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol CreateEditAlarmBuildable: Buildable {
    func build(withListener listener: CreateEditAlarmListener, mode: AlarmCreateEditMode) -> CreateEditAlarmRouting
}

final class CreateEditAlarmBuilder: Builder<CreateEditAlarmDependency>, CreateEditAlarmBuildable {

    override init(dependency: CreateEditAlarmDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CreateEditAlarmListener, mode: AlarmCreateEditMode) -> CreateEditAlarmRouting {
        let component = CreateEditAlarmComponent(dependency: dependency, mode: mode)
        let viewController = CreateEditAlarmViewController()
        let interactor = CreateEditAlarmInteractor(
            presenter: viewController,
            mode: component.mode,
            createAlarmStream: component.createAlarmStream
        )
        interactor.listener = listener
        return CreateEditAlarmRouter(interactor: interactor, viewController: viewController)
    }
}
