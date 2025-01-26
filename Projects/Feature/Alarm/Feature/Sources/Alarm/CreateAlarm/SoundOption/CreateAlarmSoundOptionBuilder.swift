//
//  CreateAlarmSoundOptionBuilder.swift
//  FeatureAlarm
//
//  Created by ever on 1/26/25.
//

import RIBs

protocol CreateAlarmSoundOptionDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class CreateAlarmSoundOptionComponent: Component<CreateAlarmSoundOptionDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol CreateAlarmSoundOptionBuildable: Buildable {
    func build(withListener listener: CreateAlarmSoundOptionListener) -> CreateAlarmSoundOptionRouting
}

final class CreateAlarmSoundOptionBuilder: Builder<CreateAlarmSoundOptionDependency>, CreateAlarmSoundOptionBuildable {

    override init(dependency: CreateAlarmSoundOptionDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CreateAlarmSoundOptionListener) -> CreateAlarmSoundOptionRouting {
        let component = CreateAlarmSoundOptionComponent(dependency: dependency)
        let viewController = CreateAlarmSoundOptionViewController()
        let interactor = CreateAlarmSoundOptionInteractor(presenter: viewController)
        interactor.listener = listener
        return CreateAlarmSoundOptionRouter(interactor: interactor, viewController: viewController)
    }
}
