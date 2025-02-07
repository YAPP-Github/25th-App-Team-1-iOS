//
//  MainPageBuilder.swift
//  FeatureMain
//
//  Created by choijunios on 1/27/25.
//

import RIBs
import FeatureAlarm

protocol MainPageDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MainPageComponent: Component<MainPageDependency> {
    let viewController: MainPageViewControllable
    init(dependency: MainPageDependency, viewController: MainPageViewControllable) {
        self.viewController = viewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol MainPageBuildable: Buildable {
    func build(withListener listener: MainPageListener) -> MainPageRouting
}

final class MainPageBuilder: Builder<MainPageDependency>, MainPageBuildable {

    override init(dependency: MainPageDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MainPageListener) -> MainPageRouting {
        let viewController = MainPageViewController()
        let component = MainPageComponent(dependency: dependency, viewController: viewController)
        let interactor = MainPageInteractor(presenter: viewController)
        interactor.listener = listener
        
        let alarmBuilder = FeatureAlarm.RootBuilder(dependency: component)
        return MainPageRouter(
            interactor: interactor,
            viewController: viewController,
            alarmBuilder: alarmBuilder
        )
    }
}
