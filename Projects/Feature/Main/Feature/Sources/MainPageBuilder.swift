//
//  MainPageBuilder.swift
//  FeatureMain
//
//  Created by choijunios on 1/27/25.
//

import FeatureAlarm
import FeatureFortune
import FeatureSetting
import FeatureAlarmController
import FeatureLogger

import RIBs

public protocol MainPageDependency: Dependency {
    var alarmController: AlarmController { get }
    var logger: Logger { get }
}

final class MainPageComponent: Component<MainPageDependency> {
    let viewController: MainPageViewControllable
    var logger: Logger { dependency.logger }
    
    init(dependency: MainPageDependency, viewController: MainPageViewControllable) {
        self.viewController = viewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol MainPageBuildable: Buildable {
    func build(withListener listener: MainPageListener) -> MainPageRouting
}

public final class MainPageBuilder: Builder<MainPageDependency>, MainPageBuildable {

    public override init(dependency: MainPageDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: MainPageListener) -> MainPageRouting {
        let viewController = MainPageViewController()
        let component = MainPageComponent(dependency: dependency, viewController: viewController)
        let interactor = MainPageInteractor(
            presenter: viewController,
            alarmController: dependency.alarmController
        )
        interactor.listener = listener
        
        let alarmBuilder = FeatureAlarm.RootBuilder(dependency: component)
        let fortuneBuilder = FeatureFortune.FortuneBuilder(dependency: component)
        let settingBuilder = SettingMainBuilder(dependency: component)
        let router = MainPageRouter(
            interactor: interactor,
            viewController: viewController,
            alarmBuilder: alarmBuilder,
            fortuneBuilder: fortuneBuilder,
            settingBuilder: settingBuilder
        )
        
        return router
    }
}
