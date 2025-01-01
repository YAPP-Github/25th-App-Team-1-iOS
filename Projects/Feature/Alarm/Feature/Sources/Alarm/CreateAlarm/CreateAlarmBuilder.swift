//
//  CreateAlarmBuilder.swift
//  FeatureAlarm
//
//  Created by ever on 12/30/24.
//

import RIBs

protocol CreateAlarmDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class CreateAlarmComponent: Component<CreateAlarmDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol CreateAlarmBuildable: Buildable {
    func build(withListener listener: CreateAlarmListener) -> CreateAlarmRouting
}

final class CreateAlarmBuilder: Builder<CreateAlarmDependency>, CreateAlarmBuildable {

    override init(dependency: CreateAlarmDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CreateAlarmListener) -> CreateAlarmRouting {
        let component = CreateAlarmComponent(dependency: dependency)
        let viewController = CreateAlarmViewController()
        let interactor = CreateAlarmInteractor(presenter: viewController)
        interactor.listener = listener
        return CreateAlarmRouter(interactor: interactor, viewController: viewController)
    }
}
