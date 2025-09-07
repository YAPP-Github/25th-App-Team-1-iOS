//
//  NFNotificationBuilder.swift
//  FeatureMain
//
//  Created by choijunios on 9/7/25.
//

import RIBs

protocol NFNotificationDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class NFNotificationComponent: Component<NFNotificationDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol NFNotificationBuildable: Buildable {
    func build(withListener listener: NFNotificationListener) -> NFNotificationRouting
}

final class NFNotificationBuilder: Builder<NFNotificationDependency>, NFNotificationBuildable {

    override init(dependency: NFNotificationDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: NFNotificationListener) -> NFNotificationRouting {
        let component = NFNotificationComponent(dependency: dependency)
        let viewController = NFNotificationViewController()
        let interactor = NFNotificationInteractor(presenter: viewController)
        interactor.listener = listener
        return NFNotificationRouter(interactor: interactor, viewController: viewController)
    }
}
