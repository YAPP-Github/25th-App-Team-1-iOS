//
//  ConfigureUserInfoBuilder.swift
//  FeatureSetting
//
//  Created by choijunios on 2/13/25.
//

import FeatureCommonEntity

import RIBs

protocol ConfigureUserInfoDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ConfigureUserInfoComponent: Component<ConfigureUserInfoDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ConfigureUserInfoBuildable: Buildable {
    func build(userInfo: UserInfo, withListener listener: ConfigureUserInfoListener) -> ConfigureUserInfoRouting
}

final class ConfigureUserInfoBuilder: Builder<ConfigureUserInfoDependency>, ConfigureUserInfoBuildable {

    override init(dependency: ConfigureUserInfoDependency) {
        super.init(dependency: dependency)
    }

    func build(userInfo: UserInfo, withListener listener: ConfigureUserInfoListener) -> ConfigureUserInfoRouting {
        let component = ConfigureUserInfoComponent(dependency: dependency)
        let viewController = ConfigureUserInfoViewController()
        let interactor = ConfigureUserInfoInteractor(
            userInfo: userInfo,
            presenter: viewController
        )
        interactor.listener = listener
        return ConfigureUserInfoRouter(interactor: interactor, viewController: viewController)
    }
}
