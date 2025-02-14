//
//  FortuneBuilder.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import RIBs
import FeatureCommonDependencies

public protocol FortuneDependency: Dependency {}

final class FortuneComponent: Component<FortuneDependency> {
    fileprivate let fortune: Fortune
    
    init(dependency: FortuneDependency, fortune: Fortune) {
        self.fortune = fortune
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol FortuneBuildable: Buildable {
    func build(withListener listener: FortuneListener, fortune: Fortune) -> FortuneRouting
}

public final class FortuneBuilder: Builder<FortuneDependency>, FortuneBuildable {

    public override init(dependency: FortuneDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: FortuneListener, fortune: Fortune) -> FortuneRouting {
        let component = FortuneComponent(dependency: dependency, fortune: fortune)
        let viewController = FortuneViewController()
        let interactor = FortuneInteractor(presenter: viewController, fortune: fortune)
        interactor.listener = listener
        return FortuneRouter(interactor: interactor, viewController: viewController)
    }
}
