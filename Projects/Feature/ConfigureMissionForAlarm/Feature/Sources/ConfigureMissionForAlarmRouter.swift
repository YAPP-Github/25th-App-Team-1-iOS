//
//  ConfigureMissionForAlarmRouter.swift
//  FeatureConfigureMissionForAlarm
//
//  Created by choijunios on 7/21/25.
//

import UIKit

import FeatureCommonEntity
import FeatureAlarmMission

import RIBs

protocol ConfigureMissionForAlarmInteractable: Interactable, AlarmMissionRootListener {
    var router: ConfigureMissionForAlarmRouting? { get set }
    var listener: ConfigureMissionForAlarmListener? { get set }
}

protocol ConfigureMissionForAlarmViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ConfigureMissionForAlarmRouter: ViewableRouter<ConfigureMissionForAlarmInteractable, ConfigureMissionForAlarmViewControllable>, ConfigureMissionForAlarmRouting {

    private let alarmMissionBuilder: AlarmMissionRootBuildable
    private var alarmMissionRouting: AlarmMissionRootRouting?
    
    init(
        interactor: ConfigureMissionForAlarmInteractable, 
        viewController: ConfigureMissionForAlarmViewControllable,
        alarmMissionBuilder: AlarmMissionRootBuildable
    ) {
        self.alarmMissionBuilder = alarmMissionBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToMissionPreview(mission: Mission, isPreviewMode: Bool) {
        guard alarmMissionRouting == nil else { return }
        
        // AlarmMissionRootBuilder의 설계 문제를 해결하기 위해
        // ConfigureMissionForAlarm ViewController를 navigationController 파라미터로 전달
        // (AlarmMissionRootBuilder는 이것을 viewController로 사용함)
        let currentViewController = viewController.uiviewController
        
        // UIViewController를 UINavigationController로 캐스팅하기 위해 임시 변수 사용
        let mockNavigationController = MockNavigationControllerForAlarmMission(presentingViewController: currentViewController)
        
        let routing = alarmMissionBuilder.build(
            withListener: interactor,
            navigationController: mockNavigationController,
            mission: mission,
            isPreviewMode: isPreviewMode
        )
        
        self.alarmMissionRouting = routing
        attachChild(routing)
    }
    
    private func generateNavigationControllerForPreview() -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }
    
    func detachMissionPreview() {
        guard let routing = alarmMissionRouting else { return }
        alarmMissionRouting = nil
        detachChild(routing)
        // AlarmMissionRootRouter가 자체적으로 dismiss 처리
    }
}

// AlarmMissionRootBuilder의 설계 문제를 해결하기 위한 Mock 클래스
// AlarmMissionRootRouter는 navigationController 파라미터를 viewController로 사용함
private class MockNavigationControllerForAlarmMission: UINavigationController {
    private let actualPresentingViewController: UIViewController
    
    init(presentingViewController: UIViewController) {
        self.actualPresentingViewController = presentingViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        // AlarmMissionRootRouter에서 present를 호출할 때 실제 presenting ViewController에서 present
        actualPresentingViewController.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
