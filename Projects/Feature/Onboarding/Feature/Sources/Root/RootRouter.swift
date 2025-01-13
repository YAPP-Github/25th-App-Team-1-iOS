//
//  RootRouter.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import RIBs
import UIKit

protocol RootInteractable: Interactable, IntroListener, InputNameListener, InputBornTimeListener, InputGenderListener, InputWakeUpAlarmListener, InputBirthDateListener, AuthorizationRequestListener, AuthorizationDeniedListener {
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
        introBuilder: IntroBuildable,
        inputNameBuilder: InputNameBuilder,
        inputBornTimeBuilder: InputBornTimeBuildable,
        inputGenderBuilder: InputGenderBuildable,
        inputWakeUpAlarmBuilder: InputWakeUpAlarmBuildable,
        inputBirthDateBuilder: InputBirthDateBuildable,
        authorizationRequestBuilder: AuthorizationRequestBuildable,
        authorizationDeniedBuilder: AuthorizationDeniedBuildable
    ) {
        self.viewController = viewController
        self.introBuilder = introBuilder
        self.inputNameBuilder = inputNameBuilder
        self.inputBornTimeBuilder = inputBornTimeBuilder
        self.inputGenderBuilder = inputGenderBuilder
        self.inputWakeUpAlarmBuilder = inputWakeUpAlarmBuilder
        self.inputBirthDateBuilder = inputBirthDateBuilder
        self.authorizationRequestBuilder = authorizationRequestBuilder
        self.authorizationDeniedBuilder = authorizationDeniedBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }

    func request(_ request: RootRouterRequest) {
        switch request {
        case .cleanUpViews:
            cleanupViews()
        case .routeToIntro:
            routeToIntro()
        case .routeToInputBirthDate:
            routeToInputBirthDate()
        case .routeToInputBornTime:
            routeToInputBornTime()
        case .detachInputBornTime:
            detachInputBornTime()
        case .routeToInputName:
            routeToInputName()
        case .detachInputName:
            detachInputName()
        case .routeToInputGender:
            routeToInputGender()
        case .detachInputGender:
            detachInputGender()
        case .routeToInputWakeUpAlarm:
            routeToInputWakeUpAlarm()
        case .routeToAuthorizationRequest:
            routeToAuthorizationRequest()
        case .detachAuthorizationRequest:
            detachAuthorizationRequest()
        case .routeToAuthorizationDenied:
            routeToAuthorizationDenied()
        case .detachAuthorizationDenied:
            detachAuthorizationDenied()
        }
    }
    
    // MARK: - Private

    private let viewController: RootViewControllable
    private var navigationController: UINavigationController?
    
    private let introBuilder: IntroBuildable
    private var introRouter: IntroRouting?
    
    private let inputNameBuilder: InputNameBuildable
    private var inputNameRouter: InputNameRouting?
    
    private let inputBornTimeBuilder: InputBornTimeBuildable
    private var inputBornTimeRouter: InputBornTimeRouting?
    
    private let inputGenderBuilder: InputGenderBuildable
    private var inputGenderRouter: InputGenderRouting?
    
    private let inputWakeUpAlarmBuilder: InputWakeUpAlarmBuildable
    private var inputWakeUpAlarmRouter: InputWakeUpAlarmRouting?
    private let inputBirthDateBuilder: InputBirthDateBuildable
    private var inputBirthDateRouter: InputBirthDateRouting?
    
    private let authorizationRequestBuilder: AuthorizationRequestBuildable
    private var authorizationRequestRouter: AuthorizationRequestRouting?
    
    private let authorizationDeniedBuilder: AuthorizationDeniedBuildable
    private var authorizationDeniedRouter: AuthorizationDeniedRouting?
    
    private func cleanupViews() {
        
    }
    
    private func presentOrPushViewController(with router: ViewableRouting) {
        if let navigationController {
            navigationController.pushViewController(router.viewControllable.uiviewController, animated: true)
        } else {
            let navigationController = UINavigationController(rootViewController: router.viewControllable.uiviewController)
            navigationController.modalPresentationStyle = .fullScreen
            viewController.uiviewController.present(navigationController, animated: true)
            self.navigationController = navigationController
        }
    }
    
    private func dismissOrPopViewController() {
        if let navigationController,
           navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            viewController.uiviewController.dismiss(animated: true)
        }
    }

    private func routeToIntro() {
        guard introRouter == nil else { return }
        let router = introBuilder.build(withListener: interactor)
        introRouter = router
        attachChild(router)
        presentOrPushViewController(with: router)
    }
    
    private func routeToInputWakeUpAlarm() {
        guard inputWakeUpAlarmRouter == nil else { return }
        let router = inputWakeUpAlarmBuilder.build(withListener: interactor)
        inputWakeUpAlarmRouter = router
        attachChild(router)
        presentOrPushViewController(with: router)
    }
    
    private func routeToInputBirthDate() {
        guard inputBirthDateRouter == nil else { return }
        let router = inputBirthDateBuilder.build(withListener: interactor)
        inputBirthDateRouter = router
        attachChild(router)
        presentOrPushViewController(with: router)
    }
    
    private func routeToInputBornTime() {
        guard inputBornTimeRouter == nil else { return }
        let router = inputBornTimeBuilder.build(withListener: interactor)
        inputBornTimeRouter = router
        attachChild(router)
        presentOrPushViewController(with: router)
    }
    
    private func detachInputBornTime() {
        guard let router = inputBornTimeRouter else { return }
        inputBornTimeRouter = nil
        detachChild(router)
        dismissOrPopViewController()
    }
    
    private func routeToInputName() {
        guard inputNameRouter == nil else { return }
        let router = inputNameBuilder.build(withListener: interactor)
        inputNameRouter = router
        attachChild(router)
        presentOrPushViewController(with: router)
    }
    
    private func detachInputName() {
        guard let router = inputNameRouter else { return }
        inputNameRouter = nil
        detachChild(router)
        dismissOrPopViewController()
    }
    
    private func routeToInputGender() {
        guard inputGenderRouter == nil else { return }
        let router = inputGenderBuilder.build(withListener: interactor)
        inputGenderRouter = router
        attachChild(router)
        presentOrPushViewController(with: router)
    }
    
    private func detachInputGender() {
        guard let router = inputGenderRouter else { return }
        inputGenderRouter = nil
        detachChild(router)
        dismissOrPopViewController()
    }
    
    private func routeToAuthorizationRequest() {
        guard authorizationRequestRouter == nil else { return }
        let router = authorizationRequestBuilder.build(withListener: interactor)
        authorizationRequestRouter = router
        attachChild(router)
        presentOrPushViewController(with: router)
    }
    
    private func detachAuthorizationRequest() {
        guard let router = authorizationRequestRouter else { return }
        authorizationRequestRouter = nil
        detachChild(router)
        dismissOrPopViewController()
    }
    
    private func routeToAuthorizationDenied() {
        guard authorizationDeniedRouter == nil else { return }
        let router = authorizationDeniedBuilder.build(withListener: interactor)
        authorizationDeniedRouter = router
        attachChild(router)
        presentOrPushViewController(with: router)
    }
    
    private func detachAuthorizationDenied() {
        guard let router = authorizationDeniedRouter else { return }
        authorizationDeniedRouter = nil
        detachChild(router)
        viewController.uiviewController.dismiss(animated: true)
    }
}
