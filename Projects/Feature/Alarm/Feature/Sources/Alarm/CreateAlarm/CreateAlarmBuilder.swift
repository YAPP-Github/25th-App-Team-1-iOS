//
//  CreateAlarmBuilder.swift
//  FeatureAlarm
//
//  Created by ever on 12/30/24.
//

import RIBs

enum AlarmCreateEditMode {
    case create
    case edit(Alarm)
}

protocol CreateAlarmDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class CreateAlarmComponent: Component<CreateAlarmDependency> {
    fileprivate let mode: AlarmCreateEditMode
    
    init(dependency: CreateAlarmDependency,
         mode: AlarmCreateEditMode
    ) {
        self.mode = mode
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
        let interactor = CreateAlarmInteractor(presenter: viewController, mode: component.mode)
        interactor.listener = listener
        return CreateAlarmRouter(interactor: interactor, viewController: viewController)
    }
}
