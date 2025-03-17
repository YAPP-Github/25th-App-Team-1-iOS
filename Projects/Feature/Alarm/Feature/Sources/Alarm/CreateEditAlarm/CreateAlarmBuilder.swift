//
//  CreateEditAlarmBuilder.swift
//  FeatureAlarm
//
//  Created by ever on 12/30/24.
//

import FeatureCommonDependencies
import FeatureLogger

import RIBs

public enum AlarmCreateEditMode {
    case create
    case edit(Alarm)
}

protocol CreateEditAlarmDependency: Dependency {
    var createAlarmStream: CreateEditAlarmStream { get }
    var logger: Logger { get }
}

final class CreateEditAlarmComponent: Component<CreateEditAlarmDependency> {
    fileprivate let mode: AlarmCreateEditMode
    fileprivate var createAlarmStream: CreateEditAlarmStream {
        shared {
            dependency.createAlarmStream
        }
    }
    init(dependency: CreateEditAlarmDependency,
         mode: AlarmCreateEditMode
    ) {
        self.mode = mode
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
            createAlarmStream: component.createAlarmStream,
            logger: dependency.logger
        )
        interactor.listener = listener
        return CreateEditAlarmRouter(interactor: interactor, viewController: viewController)
    }
}
