//
//  RootRouter.swift
//  FeatureAlarm
//
//  Created by ever on 1/1/25.
//

import RIBs
import UIKit
import FeatureResources
import FeatureCommonDependencies

protocol RootInteractable: Interactable, CreateEditAlarmListener, CreateEditAlarmSnoozeOptionListener, CreateEditAlarmSoundOptionListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

public protocol RootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
}

final class RootRouter: Router<RootInteractable>, RootRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: RootInteractable,
        viewController: RootViewControllable,
        createAlarmBuilder: CreateEditAlarmBuildable,
        snoozeOptionBuilder: CreateEditAlarmSnoozeOptionBuildable,
        soundOptionBuilder: CreateEditAlarmSoundOptionBuildable
    ) {
        self.viewController = viewController
        self.createAlarmBuilder = createAlarmBuilder
        self.snoozeOptionBuilder = snoozeOptionBuilder
        self.soundOptionBuilder = soundOptionBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }

    func request(_ request: RootRouterRequest) {
        switch request {
        case .cleanupViews:
            cleanupViews()
        case let .routeToCreateEditAlarm(mode):
            routeToCreateEditAlarm(mode: mode)
        case let .routeToSnoozeOption(snoozeOption):
            routeToSnoozeOption(snoozeOption: snoozeOption)
        case .detachSnoozeOption:
            detachSnoozeOption()
        case let .routeToSoundOption(soundOption):
            routeToSoundOption(soundOption: soundOption)
        case .detachSoundOption:
            detachSoundOption()
        }
    }
    
    // MARK: - Private

    private let viewController: RootViewControllable
    
    private let createAlarmBuilder: CreateEditAlarmBuildable
    private var createAlarmRouter: CreateEditAlarmRouting?
    
    private let snoozeOptionBuilder: CreateEditAlarmSnoozeOptionBuildable
    private var snoozeOptionRouter: CreateEditAlarmSnoozeOptionRouting?
    
    private let soundOptionBuilder: CreateEditAlarmSoundOptionBuildable
    private var soundOptionRouter: CreateEditAlarmSoundOptionRouting?
    
    private func cleanupViews() {
        detachCreateEditAlarm()
    }
    
    func routeToCreateEditAlarm(mode: AlarmCreateEditMode) {
        guard createAlarmRouter == nil else { return }
        let router = createAlarmBuilder.build(withListener: interactor, mode: mode)
        self.createAlarmRouter = router
        attachChild(router)
        router.viewControllable.uiviewController.modalPresentationStyle = .fullScreen
        let createAlarmViewController = router.viewControllable.uiviewController
        viewController.uiviewController.present(createAlarmViewController, animated: true)
    }
    
    func detachCreateEditAlarm() {
        guard let router = createAlarmRouter else { return }
        createAlarmRouter = nil
        detachChild(router)
        viewController.uiviewController.dismiss(animated: true)
    }
    
    func routeToSnoozeOption(snoozeOption: SnoozeOption) {
        guard snoozeOptionRouter == nil else { return }
        let router = snoozeOptionBuilder.build(withListener: interactor, snoozeOption: snoozeOption)
        self.snoozeOptionRouter = router
        attachChild(router)
        router.viewControllable.uiviewController.modalPresentationStyle = .overCurrentContext
        router.viewControllable.uiviewController.modalTransitionStyle = .crossDissolve
        createAlarmRouter?.viewControllable.uiviewController.present(router.viewControllable.uiviewController, animated: true)
    }
    
    func detachSnoozeOption() {
        guard let router = snoozeOptionRouter else { return }
        snoozeOptionRouter = nil
        detachChild(router)
        router.viewControllable.uiviewController.dismiss(animated: true)
    }
    
    func routeToSoundOption(soundOption: SoundOption) {
        guard soundOptionRouter == nil else { return }
        let router = soundOptionBuilder.build(withListener: interactor, soundOption: soundOption)
        self.soundOptionRouter = router
        attachChild(router)
        router.viewControllable.uiviewController.modalPresentationStyle = .overCurrentContext
        router.viewControllable.uiviewController.modalTransitionStyle = .crossDissolve
        createAlarmRouter?.viewControllable.uiviewController.present(router.viewControllable.uiviewController, animated: true)
    }
    
    func detachSoundOption() {
        guard let router = soundOptionRouter else { return }
        soundOptionRouter = nil
        detachChild(router)
        router.viewControllable.uiviewController.dismiss(animated: true)
    }
}
