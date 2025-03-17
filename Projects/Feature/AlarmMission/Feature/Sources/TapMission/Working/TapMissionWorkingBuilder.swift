//
//  TapMissionWorkingBuilder.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 3/4/25.
//

import FeatureLogger

import RIBs

protocol TapMissionWorkingDependency: Dependency {
    var logger: Logger { get }
}

final class TapMissionWorkingComponent: Component<TapMissionWorkingDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TapMissionWorkingBuildable: Buildable {
    func build(withListener listener: TapMissionWorkingListener) -> TapMissionWorkingRouting
}

final class TapMissionWorkingBuilder: Builder<TapMissionWorkingDependency>, TapMissionWorkingBuildable {

    override init(dependency: TapMissionWorkingDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TapMissionWorkingListener) -> TapMissionWorkingRouting {
        let component = TapMissionWorkingComponent(dependency: dependency)
        let viewController = TapMissionWorkingViewController()
        let interactor = TapMissionWorkingInteractor(presenter: viewController, logger: dependency.logger)
        interactor.listener = listener
        return TapMissionWorkingRouter(interactor: interactor, viewController: viewController)
    }
}
