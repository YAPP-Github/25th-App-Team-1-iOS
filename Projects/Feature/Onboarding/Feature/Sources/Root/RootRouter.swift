//
//  RootRouter.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import RIBs
import UIKit

protocol RootInteractable: Interactable, OnboardingIntroListener, InputNameListener, InputBornTimeListener, InputGenderListener, InputWakeUpAlarmListener, InputBirthDateListener, AuthorizationRequestListener, AuthorizationDeniedListener, OnboardingMissionGuideListener, OnboardingFortuneGuideListener, InputSummaryListener {
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
        introBuilder: OnboardingIntroBuildable,
        inputWakeUpAlarmBuilder: InputWakeUpAlarmBuildable,
        inputBirthDateBuilder: InputBirthDateBuildable,
        inputBornTimeBuilder: InputBornTimeBuildable,
        inputNameBuilder: InputNameBuilder,
        inputGenderBuilder: InputGenderBuildable,
        authorizationRequestBuilder: AuthorizationRequestBuildable,
        authorizationDeniedBuilder: AuthorizationDeniedBuildable,
        onboardingMissionGuideBuilder: OnboardingMissionGuideBuildable,
        onboardingFortuneGuideBuilder: OnboardingFortuneGuideBuildable,
        inputSummaryBuilder: InputSummaryBuilder
    ) {
        self.viewController = viewController
        self.introBuilder = introBuilder
        self.inputWakeUpAlarmBuilder = inputWakeUpAlarmBuilder
        self.inputBirthDateBuilder = inputBirthDateBuilder
        self.inputBornTimeBuilder = inputBornTimeBuilder
        self.inputNameBuilder = inputNameBuilder
        self.inputGenderBuilder = inputGenderBuilder
        self.authorizationRequestBuilder = authorizationRequestBuilder
        self.authorizationDeniedBuilder = authorizationDeniedBuilder
        self.onboardingMissionGuideBuilder = onboardingMissionGuideBuilder
        self.onboardingFortuneGuideBuilder = onboardingFortuneGuideBuilder
        self.inputSummaryBuilder = inputSummaryBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }

    func request(_ request: RootRouterRequest) {
        switch request {
        case .cleanUpViews:
            cleanupViews()
        case .routeToIntro:
            routeToIntro()
        case let .routeToInputWakeUpAlarm(model):
            routeToInputWakeUpAlarm(model: model)
        case .detachInputWakeUpAlarm:
            detachInputWakeUpAlarm()
        case let .routeToInputBirthDate(model):
            routeToInputBirthDate(model: model)
        case .detachInputBirthDate:
            detachInputBirthDate()
        case let .routeToInputBornTime(model):
            routeToInputBornTime(model: model)
        case .detachInputBornTime:
            detachInputBornTime()
        case let .routeToInputName(model):
            routeToInputName(model: model)
        case .detachInputName:
            detachInputName()
        case let .routeToInputGender(model):
            routeToInputGender(model: model)
        case .detachInputGender:
            detachInputGender()
        case .routeToAuthorizationRequest:
            routeToAuthorizationRequest()
        case .detachAuthorizationRequest:
            detachAuthorizationRequest()
        case .routeToAuthorizationDenied:
            routeToAuthorizationDenied()
        case .routeToMissionGuide:
            routeToMissionGuide()
        case .detachMissionGuide:
            detachMissionGuide()
        case .routeToFortuneGuide:
            routeToFortunenGuide()
        case .detachFortuneGuide:
            detachFortuneGuide()
        case let .routeToInputSummary(model):
            routeToInputSummary(model: model)
        case let .detachInputSummary(completion):
            detachInputSummary(completion: completion)
        }
    }
    
    // MARK: - Private

    private let viewController: RootViewControllable
    private var navigationController: UINavigationController?
    
    private let introBuilder: OnboardingIntroBuildable
    private var introRouter: OnboardingIntroRouting?
    
    private let inputWakeUpAlarmBuilder: InputWakeUpAlarmBuildable
    private var inputWakeUpAlarmRouter: InputWakeUpAlarmRouting?
    
    private let inputBirthDateBuilder: InputBirthDateBuildable
    private var inputBirthDateRouter: InputBirthDateRouting?
    
    private let inputBornTimeBuilder: InputBornTimeBuildable
    private var inputBornTimeRouter: InputBornTimeRouting?
    
    private let inputNameBuilder: InputNameBuildable
    private var inputNameRouter: InputNameRouting?
    
    private let inputGenderBuilder: InputGenderBuildable
    private var inputGenderRouter: InputGenderRouting?
    
    private let inputSummaryBuilder: InputSummaryBuilder
    private var inputSummaryRouter: InputSummaryRouting?
    
    private let authorizationRequestBuilder: AuthorizationRequestBuildable
    private var authorizationRequestRouter: AuthorizationRequestRouting?
    
    private let authorizationDeniedBuilder: AuthorizationDeniedBuildable
    private var authorizationDeniedRouter: AuthorizationDeniedRouting?
    
    private let onboardingMissionGuideBuilder: OnboardingMissionGuideBuildable
    private var onboardingMissionGuideRouter: OnboardingMissionGuideRouting?
    
    private let onboardingFortuneGuideBuilder: OnboardingFortuneGuideBuildable
    private var onboardingFortuneGuideRouter: OnboardingFortuneGuideRouting?
    
    private func cleanupViews() {
        if let navigationController {
            navigationController.setViewControllers([], animated: true)
            viewController.uiviewController.dismiss(animated: true)
        } else {
            // 네비게이션 컨트롤러가 없는 경우 or 현재 화면이 네비게이션의 RootVC인 경우
            viewController.uiviewController.dismiss(animated: true)
        }
    }
    
    private func presentOrPushViewController(with router: ViewableRouting, animated: Bool = true) {
        if let navigationController {
            navigationController.pushViewController(router.viewControllable.uiviewController, animated: animated)
        } else {
            let navigationController = UINavigationController(rootViewController: router.viewControllable.uiviewController)
            navigationController.modalPresentationStyle = .fullScreen
            viewController.uiviewController.present(navigationController, animated: animated)
            self.navigationController = navigationController
        }
    }
    
    private func dismissOrPopViewController(animated: Bool = true) {
        if let navigationController,
           navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: animated)
        } else {
            // 네비게이션 컨트롤러가 없는 경우 or 현재 화면이 네비게이션의 RootVC인 경우
            viewController.uiviewController.dismiss(animated: animated)
            navigationController = nil
        }
    }

    private func routeToIntro() {
        guard introRouter == nil else { return }
        let router = introBuilder.build(withListener: interactor)
        introRouter = router
        attachChild(router)
        presentOrPushViewController(with: router)
    }
    
    private func routeToInputWakeUpAlarm(model: OnboardingModel) {
        guard inputWakeUpAlarmRouter == nil else { return }
        let router = inputWakeUpAlarmBuilder.build(withListener: interactor, model: model)
        inputWakeUpAlarmRouter = router
        attachChild(router)
        presentOrPushViewController(with: router)
    }
    
    private func detachInputWakeUpAlarm() {
        guard let router = inputWakeUpAlarmRouter else { return }
        inputWakeUpAlarmRouter = nil
        detachChild(router)
        dismissOrPopViewController()
    }
    
    private func routeToInputBirthDate(model: OnboardingModel) {
        guard inputBirthDateRouter == nil else { return }
        let router = inputBirthDateBuilder.build(withListener: interactor, model: model)
        inputBirthDateRouter = router
        attachChild(router)
        presentOrPushViewController(with: router)
    }
    
    private func detachInputBirthDate() {
        guard let router = inputBirthDateRouter else { return }
        inputBirthDateRouter = nil
        detachChild(router)
        dismissOrPopViewController()
    }
    
    private func routeToInputBornTime(model: OnboardingModel) {
        guard inputBornTimeRouter == nil else { return }
        let router = inputBornTimeBuilder.build(withListener: interactor, model: model)
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
    
    private func routeToInputName(model: OnboardingModel) {
        guard inputNameRouter == nil else { return }
        let router = inputNameBuilder.build(withListener: interactor, model: model)
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
    
    private func routeToInputGender(model: OnboardingModel) {
        guard inputGenderRouter == nil else { return }
        let router = inputGenderBuilder.build(withListener: interactor, model: model)
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
    
    private func routeToMissionGuide() {
        guard onboardingMissionGuideRouter == nil else { return }
        let router = onboardingMissionGuideBuilder.build(withListener: interactor)
        onboardingMissionGuideRouter = router
        attachChild(router)
        presentOrPushViewController(with: router)
    }
    
    
    private func detachMissionGuide() {
        guard let router = onboardingMissionGuideRouter else { return }
        onboardingMissionGuideRouter = nil
        detachChild(router)
        dismissOrPopViewController()
    }
    
    private func routeToFortunenGuide() {
        guard onboardingFortuneGuideRouter == nil else { return }
        let router = onboardingFortuneGuideBuilder.build(withListener: interactor)
        onboardingFortuneGuideRouter = router
        attachChild(router)
        presentOrPushViewController(with: router)
    }
    
    private func detachFortuneGuide() {
        guard let router = onboardingFortuneGuideRouter else { return }
        onboardingFortuneGuideRouter = nil
        detachChild(router)
        dismissOrPopViewController()
    }
    
    private func routeToInputSummary(model: OnboardingModel) {
        guard inputSummaryRouter == nil else { return }
        let router = inputSummaryBuilder.build(
            withListener: interactor,
            model: model
        )
        inputSummaryRouter = router
        attachChild(router)
        
        router.viewControllable.uiviewController.modalPresentationStyle = .overFullScreen
        
        
        if let navigationController {
            navigationController
                .present(router.viewControllable.uiviewController, animated: false)
        } else {
            viewController.uiviewController
                .present(router.viewControllable.uiviewController, animated: false)
        }
    }
    
    private func detachInputSummary(completion: (() -> Void)?) {
        guard let router = inputSummaryRouter else { return }
        inputSummaryRouter = nil
        detachChild(router)
        if let navigationController {
            navigationController.dismiss(animated: true, completion: completion)
        } else {
            viewController.uiviewController
                .dismiss(animated: true, completion: completion)
        }
    }
}
