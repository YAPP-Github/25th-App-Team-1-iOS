//
//  FortuneBuilder.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import RIBs

public protocol FortuneDependency: Dependency {}

final class FortuneComponent: Component<FortuneDependency> {
}

// MARK: - Builder

public protocol FortuneBuildable: Buildable {
    func build(withListener listener: FortuneListener) -> FortuneRouting
}

public final class FortuneBuilder: Builder<FortuneDependency>, FortuneBuildable {

    public override init(dependency: FortuneDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: FortuneListener) -> FortuneRouting {
        let component = FortuneComponent(dependency: dependency)
        let viewController = FortuneViewController()
        let interactor = FortuneInteractor(presenter: viewController)
        interactor.listener = listener
        return FortuneRouter(interactor: interactor, viewController: viewController)
    }
}
