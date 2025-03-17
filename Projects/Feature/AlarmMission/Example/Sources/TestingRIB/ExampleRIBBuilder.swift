//
//  ExampleRIBBuilder.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 3/4/25.
//

import UIKit

import FeatureAlarmMission
import FeatureLogger

import RIBs

protocol ExampleRIBDependency: Dependency {
    var logger: Logger { get }
}

final class ExampleRIBComponent: Component<ExampleRIBDependency>, AlarmMissionRootDependency {
    var logger: Logger { dependency.logger }
}

// MARK: - Builder

protocol ExampleRIBBuildable: Buildable {
    func build(withListener listener: ExampleRIBListener) -> ExampleRIBRouting
}

final class ExampleRIBBuilder: Builder<ExampleRIBDependency>, ExampleRIBBuildable {

    override init(dependency: ExampleRIBDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ExampleRIBListener) -> ExampleRIBRouting {
        let component = ExampleRIBComponent(dependency: dependency)
        let viewController = ExampleRIBViewController()
        let interactor = ExampleRIBInteractor(presenter: viewController)
        interactor.listener = listener
        let missionBuilder = AlarmMissionRootBuilder(dependency: component)
        return ExampleRIBRouter(
            interactor: interactor,
            viewController: viewController,
            missionBuilder: missionBuilder
        )
    }
    
}
