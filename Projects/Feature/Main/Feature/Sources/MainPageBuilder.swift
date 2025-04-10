//
//  MainPageBuilder.swift
//  FeatureMain
//
//  Created by choijunios on 1/27/25.
//

import FeatureAlarm
import FeatureAlarmMission
import FeatureFortune
import FeatureAlarmRelease
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
    func build(withListener listener: MainPageListener) -> (router: MainPageRouting, actionableItem: MainPageActionableItem)
}

public final class MainPageBuilder: Builder<MainPageDependency>, MainPageBuildable {

    public override init(dependency: MainPageDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: MainPageListener) -> (router: MainPageRouting, actionableItem: MainPageActionableItem) {
        let viewController = MainPageViewController()
        let component = MainPageComponent(dependency: dependency, viewController: viewController)
        let interactor = MainPageInteractor(
            presenter: viewController,
            alarmController: dependency.alarmController
        )
        interactor.listener = listener
        
        let alarmBuilder = FeatureAlarm.RootBuilder(dependency: component)
        let alarmMissionRootBuilder = FeatureAlarmMission.AlarmMissionRootBuilder(dependency: component)
        let fortuneBuilder = FeatureFortune.FortuneBuilder(dependency: component)
        let alarmReleaseBuilder = FeatureAlarmRelease.AlarmReleaseIntroBuilder(dependency: component)
        let settingBuilder = SettingMainBuilder(dependency: component)
        let router = MainPageRouter(
            interactor: interactor,
            viewController: viewController,
            alarmBuilder: alarmBuilder,
            alarmMissionRootBuilder: alarmMissionRootBuilder,
            fortuneBuilder: fortuneBuilder,
            alarmReleaseBuilder: alarmReleaseBuilder,
            settingBuilder: settingBuilder
        )
        
        return (router: router, actionableItem: interactor)
    }
}
