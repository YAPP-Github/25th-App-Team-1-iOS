//
//  RootRouter.swift
//  FeatureConfigureMissionForAlarm
//
//  Created by choijunios on 7/22/25.
//

import RIBs

import FeatureConfigureMissionForAlarm
import FeatureCommonEntity
import FeatureLogger

protocol RootInteractable: Interactable, ConfigureMissionForAlarmListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RootRouter: ViewableRouter<RootInteractable, RootViewControllable>, RootRouting {

    private var configureMissionRouter: ConfigureMissionForAlarmRouting?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RootInteractable, viewController: RootViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func presentConfigureMission(mission: Mission?) {
        
        let builder = ConfigureMissionForAlarmBuilder(
            dependency: ModuleDependency(logger: PrintOnlyLogger())
        )
        let router = builder.build(withListener: interactor, initialMission: mission)
        self.configureMissionRouter = router
        attachChild(router)
        
        self.viewController.uiviewController.present(
            router.viewControllable.uiviewController,
            animated: true
        )
    }
    
    func dismissConfigureMission() {
        guard let configureMissionRouter else { return }
        self.viewController.uiviewController.dismiss(animated: true)
        detachChild(configureMissionRouter)
        self.configureMissionRouter = nil
    }
    
    
    func request(_ request: RootRoutingRequest) {
        switch request {
        case .presentConfigureMissionForAlarm(let mission):
            presentConfigureMission(mission: mission)
        case .dismissConfigureMissionForAlarm:
            dismissConfigureMission()
        }
    }
}
