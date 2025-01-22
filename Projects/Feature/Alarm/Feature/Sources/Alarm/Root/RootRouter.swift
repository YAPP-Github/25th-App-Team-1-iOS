//
//  RootRouter.swift
//  FeatureAlarm
//
//  Created by ever on 1/1/25.
//

import RIBs
import UIKit

protocol RootInteractable: Interactable, AlarmListListener, CreateAlarmListener, CreateAlarmSnoozeOptionListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
}

final class RootRouter: Router<RootInteractable>, RootRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: RootInteractable,
        viewController: RootViewControllable,
        alarmListBuilder: AlarmListBuildable,
        createAlarmBuilder: CreateAlarmBuildable,
        snoozeOptionBuilder: CreateAlarmSnoozeOptionBuildable
    ) {
        self.viewController = viewController
        self.alarmListBuilder = alarmListBuilder
        self.createAlarmBuilder = createAlarmBuilder
        self.snoozeOptionBuilder = snoozeOptionBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }

    func request(_ request: RootRouterRequest) {
        switch request {
        case .cleanupViews:
            cleanupViews()
        case .routeToAlarmList:
            routeToAlarmList()
        case .routeToCreateAlarm:
            routeToCreateAlarm()
        case .detachCreateAlarm:
            detachCreateAlarm()
        case .routeToSnoozeOption:
            routeToSnoozeOption()
        case .detachSnoozeOption:
            detachSnoozeOption()
        }
    }
    
    // MARK: - Private

    private let viewController: RootViewControllable
    private let navigationController = UINavigationController().then {
        $0.modalPresentationStyle = .fullScreen
    }

    private let alarmListBuilder: AlarmListBuildable
    private var alarmListRouter: AlarmListRouting?
    
    private let createAlarmBuilder: CreateAlarmBuildable
    private var createAlarmRouter: CreateAlarmRouting?
    
    private let snoozeOptionBuilder: CreateAlarmSnoozeOptionBuildable
    private var snoozeOptionRouter: CreateAlarmSnoozeOptionRouting?
    
    private func cleanupViews() {
        // TODO: Since this router does not own its view, it needs to cleanup the views
        // it may have added to the view hierarchy, when its interactor is deactivated.
    }

    
    func routeToAlarmList() {
        guard alarmListRouter == nil else { return }
        let router = alarmListBuilder.build(withListener: interactor)
        self.alarmListRouter = router
        attachChild(router)
        let alarmListViewController = router.viewControllable.uiviewController
        navigationController.viewControllers = [alarmListViewController]
        viewController.uiviewController.present(navigationController, animated: true)
    }
    
    func routeToCreateAlarm() {
        guard createAlarmRouter == nil else { return }
        let router = createAlarmBuilder.build(withListener: interactor)
        self.createAlarmRouter = router
        attachChild(router)
        let createAlarmViewController = router.viewControllable.uiviewController
        navigationController.pushViewController(createAlarmViewController, animated: true)
    }
    
    func detachCreateAlarm() {
        guard let router = createAlarmRouter else { return }
        createAlarmRouter = nil
        detachChild(router)
        navigationController.popViewController(animated: true)
    }
    
    func routeToSnoozeOption() {
        guard snoozeOptionRouter == nil else { return }
        let router = snoozeOptionBuilder.build(withListener: interactor)
        self.snoozeOptionRouter = router
        attachChild(router)
        router.viewControllable.uiviewController.modalPresentationStyle = .overCurrentContext
        router.viewControllable.uiviewController.modalTransitionStyle = .crossDissolve
        navigationController.present(router.viewControllable.uiviewController, animated: true)
    }
    
    func detachSnoozeOption() {
        guard let router = snoozeOptionRouter else { return }
        snoozeOptionRouter = nil
        detachChild(router)
        router.viewControllable.uiviewController.dismiss(animated: true)
    }
}
