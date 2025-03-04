//
//  TapMissionMainBuilder.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 3/4/25.
//

import RIBs
import RxRelay

protocol TapMissionMainDependency: Dependency {
    var action: PublishRelay<MissionState> { get }
}

final class TapMissionMainComponent: Component<TapMissionMainDependency>, TapMissionWorkingDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TapMissionMainBuildable: Buildable {
    func build(withListener listener: TapMissionMainListener) -> TapMissionMainRouting
}

final class TapMissionMainBuilder: Builder<TapMissionMainDependency>, TapMissionMainBuildable {

    override init(dependency: TapMissionMainDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TapMissionMainListener) -> TapMissionMainRouting {
        let component = TapMissionMainComponent(dependency: dependency)
        let viewController = TapMissionMainViewController()
        let interactor = TapMissionMainInteractor(
            presenter: viewController,
            missionAction: dependency.action
        )
        interactor.listener = listener
        let tapMissionWorkingBuilder = TapMissionWorkingBuilder(dependency: component)
        return TapMissionMainRouter(
            interactor: interactor,
            viewController: viewController,
            tapMissionWorkingBuilder: tapMissionWorkingBuilder
        )
    }
}
