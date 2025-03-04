//
//  ExampleRIBRouter.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 3/4/25.
//

import UIKit

import RIBs

import FeatureAlarmMission

protocol ExampleRIBInteractable: Interactable, MissionRootListener {
    var router: ExampleRIBRouting? { get set }
    var listener: ExampleRIBListener? { get set }
}

protocol ExampleRIBViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ExampleRIBRouter: ViewableRouter<ExampleRIBInteractable, ExampleRIBViewControllable>, ExampleRIBRouting {

    var navigationController: UINavigationController?
    
    let missionBuilder: MissionRootBuilder
    var missionRouter: MissionRootRouting?
    
    init(
        interactor: ExampleRIBInteractable,
        viewController: ExampleRIBViewControllable,
        missionBuilder: MissionRootBuilder
    ) {
        self.missionBuilder = missionBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func presentMission(_ mission: Mission) {
        let router = missionBuilder.build(
            withListener: interactor,
            mission: mission,
            isFirstAlarm: true
        )
        self.missionRouter = router
        attachChild(router)
    }
    
    func dismissMission() {
        guard let missionRouter else { return }
        detachChild(missionRouter)
        self.missionRouter = nil
    }
}
