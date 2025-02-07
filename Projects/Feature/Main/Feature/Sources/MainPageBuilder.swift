//
//  MainPageBuilder.swift
//  FeatureMain
//
//  Created by choijunios on 1/27/25.
//

import RIBs
import FeatureAlarm
import FeatureAlarmMission
import FeatureFortune

public protocol MainPageDependency: Dependency {}

final class MainPageComponent: Component<MainPageDependency> {
    let viewController: MainPageViewControllable
    fileprivate let service: MainPageServiceable
    
    init(dependency: MainPageDependency, viewController: MainPageViewControllable, service: MainPageServiceable = MainPageService()) {
        self.viewController = viewController
        self.service = service
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
        let interactor = MainPageInteractor(presenter: viewController, service: component.service)
        interactor.listener = listener
        
        let alarmBuilder = FeatureAlarm.RootBuilder(dependency: component)
        let alarmMissionBuilder = FeatureAlarmMission.ShakeMissionMainBuilder(dependency: component)
        let fortuneBuilder = FeatureFortune.FortuneBuilder(dependency: component)
        return MainPageRouter(
            interactor: interactor,
            viewController: viewController,
            alarmBuilder: alarmBuilder,
            alarmMissionBuilder: alarmMissionBuilder,
            fortuneBuilder: fortuneBuilder
        )
    }
}
