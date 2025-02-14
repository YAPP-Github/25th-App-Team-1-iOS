//
//  SettingMainBuilder.swift
//  FeatureSetting
//
//  Created by choijunios on 2/13/25.
//

import RIBs

public protocol SettingMainDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SettingMainComponent: Component<SettingMainDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SettingMainBuildable: Buildable {
    func build(withListener listener: SettingMainListener) -> SettingMainRouting
}

public final class SettingMainBuilder: Builder<SettingMainDependency>, SettingMainBuildable {

    public override init(dependency: SettingMainDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: SettingMainListener) -> SettingMainRouting {
        let component = SettingMainComponent(dependency: dependency)
        let viewController = SettingMainViewController()
        let interactor = SettingMainInteractor(presenter: viewController)
        interactor.listener = listener
        let configureUserInfoBuilder = ConfigureUserInfoBuilder(dependency: component)
        return SettingMainRouter(
            interactor: interactor,
            viewController: viewController,
            configureUserInfoBuilder: configureUserInfoBuilder
        )
    }
}
