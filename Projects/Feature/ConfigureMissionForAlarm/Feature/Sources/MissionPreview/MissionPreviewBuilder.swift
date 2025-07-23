//
//  MissionPreviewBuilder.swift
//  FeatureConfigureMissionForAlarm
//
//  Created by choijunios on 7/23/25.
//

import RIBs

protocol MissionPreviewDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MissionPreviewComponent: Component<MissionPreviewDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol MissionPreviewBuildable: Buildable {
    func build(withListener listener: MissionPreviewListener) -> MissionPreviewRouting
}

final class MissionPreviewBuilder: Builder<MissionPreviewDependency>, MissionPreviewBuildable {

    override init(dependency: MissionPreviewDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MissionPreviewListener) -> MissionPreviewRouting {
        let component = MissionPreviewComponent(dependency: dependency)
        let viewController = MissionPreviewViewController()
        let interactor = MissionPreviewInteractor(presenter: viewController)
        interactor.listener = listener
        return MissionPreviewRouter(interactor: interactor, viewController: viewController)
    }
}
