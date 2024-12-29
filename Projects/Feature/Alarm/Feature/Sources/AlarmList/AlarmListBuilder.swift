//
//  AlarmListBuilder.swift
//  FeatureAlarmExample
//
//  Created by ever on 12/29/24.
//

import RIBs

protocol AlarmListDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AlarmListComponent: Component<AlarmListDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AlarmListBuildable: Buildable {
    func build(withListener listener: AlarmListListener) -> AlarmListRouting
}

final class AlarmListBuilder: Builder<AlarmListDependency>, AlarmListBuildable {

    override init(dependency: AlarmListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AlarmListListener) -> AlarmListRouting {
        let component = AlarmListComponent(dependency: dependency)
        let viewController = AlarmListViewController()
        let interactor = AlarmListInteractor(presenter: viewController)
        interactor.listener = listener
        return AlarmListRouter(interactor: interactor, viewController: viewController)
    }
}
