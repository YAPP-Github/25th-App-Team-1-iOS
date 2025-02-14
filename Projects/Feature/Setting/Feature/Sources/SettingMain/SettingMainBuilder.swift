//
//  SettingMainBuilder.swift
//  FeatureSetting
//
//  Created by choijunios on 2/13/25.
//

import UIKit

import RIBs

public protocol SettingMainDependency: Dependency { }

final class SettingMainComponent: Component<SettingMainDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

public protocol SettingMainBuildable: Buildable {
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
