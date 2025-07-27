//
//  ConfigureMissionForAlarmRouter.swift
//  FeatureConfigureMissionForAlarm
//
//  Created by choijunios on 7/21/25.
//

import RIBs
import FeatureAlarmMission
import UIKit

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
    
    func routeToMissionPreview(missionType: AlarmMissionType, isPreviewMode: Bool) {
        guard alarmMissionRouting == nil else { return }
        
        let navigationController = UINavigationController()
        let routing = alarmMissionBuilder.build(
            withListener: interactor,
            navigationController: navigationController,
            missionType: missionType,
            isPreviewMode: isPreviewMode
        )
        
        self.alarmMissionRouting = routing
        attachChild(routing)
        
        navigationController.modalPresentationStyle = .fullScreen
        viewController.uiviewController.present(navigationController, animated: true)
    }
    
    func detachMissionPreview() {
        guard let routing = alarmMissionRouting else { return }
        alarmMissionRouting = nil
        detachChild(routing)
    }
}
