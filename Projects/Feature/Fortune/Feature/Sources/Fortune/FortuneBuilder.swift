//
//  FortuneBuilder.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import FeatureCommonDependencies
import FeatureLogger

import RIBs

public protocol FortuneDependency: Dependency {
    var logger: Logger { get }
}

final class FortuneComponent: Component<FortuneDependency> {
    fileprivate let fortune: Fortune
    fileprivate let userInfo: UserInfo
    fileprivate let fortuneInfo: FortuneSaveInfo
    
    init(
        dependency: FortuneDependency, fortune: Fortune,
        userInfo: UserInfo,
        fortuneInfo: FortuneSaveInfo
    ) {
        self.fortune = fortune
        self.userInfo = userInfo
        self.fortuneInfo = fortuneInfo
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol FortuneBuildable: Buildable {
    func build(withListener listener: FortuneListener, fortune: Fortune, userInfo: UserInfo, fortuneInfo: FortuneSaveInfo) -> FortuneRouting
}

public final class FortuneBuilder: Builder<FortuneDependency>, FortuneBuildable {

    public override init(dependency: FortuneDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: FortuneListener, fortune: Fortune, userInfo: UserInfo, fortuneInfo: FortuneSaveInfo) -> FortuneRouting {
        let component = FortuneComponent(dependency: dependency, fortune: fortune, userInfo: userInfo, fortuneInfo: fortuneInfo)
        let viewController = FortuneViewController()
        let interactor = FortuneInteractor(presenter: viewController, fortune: fortune, userInfo: component.userInfo, fortuneInfo: component.fortuneInfo, logger: dependency.logger)
        interactor.listener = listener
        return FortuneRouter(interactor: interactor, viewController: viewController)
    }
}
