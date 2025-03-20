//
//  MainBuilder.swift
//  Orbit
//
//  Created by 손병근 on 1/4/25.
//

import FeatureOnboarding
import FeatureMain
import FeatureAlarmController
import FeatureLogger

import RIBs

protocol MainDependency: Dependency {
    var alarmController: AlarmController { get }
    var logger: Logger { get }
}

final class MainComponent: Component<MainDependency> {
    let rootViewController: MainViewControllable
    init(
        dependency: MainDependency,
        viewController: MainViewControllable
    ) {
        self.rootViewController = viewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol MainBuildable: Buildable {
    func build() -> (routing: LaunchRouting, alarmIdHandler: AlarmIdHandler)
}

final class MainBuilder: Builder<MainDependency>, MainBuildable {

    override init(dependency: MainDependency) {
        super.init(dependency: dependency)
    }

    func build() -> (routing: LaunchRouting, alarmIdHandler: AlarmIdHandler) {
        let viewController = MainViewController()
        let component = MainComponent(dependency: dependency, viewController: viewController)
        
        let interactor = MainInteractor(
            presenter: viewController,
            alarmController: dependency.alarmController
        )
        let onboardingBuilder = FeatureOnboarding.RootBuilder(dependency: component)
        let mainBuilder = FeatureMain.MainPageBuilder(dependency: component)
        let router = MainRouter(
            interactor: interactor,
            viewController: viewController,
            onboardingBuilder: onboardingBuilder,
            mainBuilder: mainBuilder
        )
        
        return (router, interactor)
    }
}
