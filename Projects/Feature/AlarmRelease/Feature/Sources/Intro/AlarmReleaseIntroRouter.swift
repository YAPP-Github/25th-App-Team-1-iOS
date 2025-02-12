//
//  AlarmReleaseIntroRouter.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/10/25.
//

import RIBs
import UIKit
import FeatureCommonDependencies

protocol AlarmReleaseIntroInteractable: Interactable, AlarmReleaseSnoozeListener {
    var router: AlarmReleaseIntroRouting? { get set }
    var listener: AlarmReleaseIntroListener? { get set }
}

protocol AlarmReleaseIntroViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AlarmReleaseIntroRouter: ViewableRouter<AlarmReleaseIntroInteractable, AlarmReleaseIntroViewControllable>, AlarmReleaseIntroRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: AlarmReleaseIntroInteractable,
        viewController: AlarmReleaseIntroViewControllable,
        snoozeBuilder: AlarmReleaseSnoozeBuildable)
    {
        self.snoozeBuilder = snoozeBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func request(_ request: AlarmReleaseIntroRouterRequest) {
        switch request {
        case let .routeToSnooze(option):
            routeToSnooze(snoozeOption: option)
        case .detachSnooze:
            detachSnooze()
        }
    }
    
    private let snoozeBuilder: AlarmReleaseSnoozeBuildable
    private var snoozeRouter: AlarmReleaseSnoozeRouting?
    
    private func routeToSnooze(snoozeOption: SnoozeOption) {
        guard snoozeRouter == nil else { return }
        let router = snoozeBuilder.build(withListener: interactor, snoozeOption: snoozeOption)
        self.snoozeRouter = router
        attachChild(router)
        viewController.uiviewController.navigationController?.pushViewController(router.viewControllable.uiviewController, animated: true)
    }
    
    private func detachSnooze() {
        guard let router = snoozeRouter else { return }
        self.snoozeRouter = nil
        detachChild(router)
        viewController.uiviewController.navigationController?.popViewController(animated: false)
    }
}
