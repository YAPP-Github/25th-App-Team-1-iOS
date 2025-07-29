//
//  ShakeMissionWorkingBuilder.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 1/20/25.
//

import FeatureLogger

import RIBs

protocol ShakeMissionWorkingDependency: Dependency {
    var logger: Logger { get }
}

final class ShakeMissionWorkingComponent: Component<ShakeMissionWorkingDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ShakeMissionWorkingBuildable: Buildable {
    func build(withListener listener: ShakeMissionWorkingListener, successCount: Int, isPreviewMode: Bool) -> ShakeMissionWorkingRouting
}

final class ShakeMissionWorkingBuilder: Builder<ShakeMissionWorkingDependency>, ShakeMissionWorkingBuildable {

    override init(dependency: ShakeMissionWorkingDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: ShakeMissionWorkingListener, successCount: Int, isPreviewMode: Bool) -> ShakeMissionWorkingRouting {
        let component = ShakeMissionWorkingComponent(dependency: dependency)
        let viewController = ShakeMissionWorkingViewController()
        let interactor = ShakeMissionWorkingInteractor(
            presenter: viewController,
            logger: dependency.logger,
            successCount: successCount,
            isPreviewMode: isPreviewMode
        )
        interactor.listener = listener
        return ShakeMissionWorkingRouter(interactor: interactor, viewController: viewController)
    }
}
