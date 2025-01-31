//
//  MainPageBuilder.swift
//  FeatureMain
//
//  Created by choijunios on 1/27/25.
//

import RIBs

protocol MainPageDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MainPageComponent: Component<MainPageDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
        let component = MainPageComponent(dependency: dependency)
        let viewController = MainPageViewController()
        let interactor = MainPageInteractor(presenter: viewController)
        interactor.listener = listener
        return MainPageRouter(interactor: interactor, viewController: viewController)
    }
}
