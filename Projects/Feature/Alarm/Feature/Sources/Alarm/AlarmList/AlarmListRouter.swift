//
//  AlarmListRouter.swift
//  FeatureAlarmExample
//
//  Created by ever on 12/29/24.
//

import RIBs

protocol AlarmListInteractable: Interactable {
    var router: AlarmListRouting? { get set }
    var listener: AlarmListListener? { get set }
}

protocol AlarmListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AlarmListRouter: ViewableRouter<AlarmListInteractable, AlarmListViewControllable>, AlarmListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AlarmListInteractable, viewController: AlarmListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
