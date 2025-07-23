//
//  ConfigureMissionForAlarmInteractor.swift
//  FeatureConfigureMissionForAlarm
//
//  Created by choijunios on 7/21/25.
//

import RIBs
import RxSwift

public protocol ConfigureMissionForAlarmRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ConfigureMissionForAlarmPresentable: Presentable {
    var listener: ConfigureMissionForAlarmPresentableListener? { get set }
    func update(_ update: ConfigureMissionForAlarmPresentableUpdate)
}

enum ConfigureMissionForAlarmPresentableUpdate {
    case presentMissionList(items: [MissionItemRenderObject])
    case presentMissionConditionSetting(item: MissionItemRenderObject)
    case dismissMissionList
    case dismissMissionConditionSetting
    case selecteMissionCondition(index: Int)
}

public protocol ConfigureMissionForAlarmListener: AnyObject {
    func request(_ request: ConfigureMissionForAlarmListenerRequest)
}

public enum ConfigureMissionForAlarmListenerRequest {
    case dismissScreen
}

final class ConfigureMissionForAlarmInteractor: PresentableInteractor<ConfigureMissionForAlarmPresentable>, ConfigureMissionForAlarmInteractable, ConfigureMissionForAlarmPresentableListener {

    weak var router: ConfigureMissionForAlarmRouting?
    weak var listener: ConfigureMissionForAlarmListener?

    
    // State
    // - Navigation
    private var processStack: [ConfigureProcess] = []
    
    // - Mission
    private var currentSelectedMission: MissionItemRenderObject?
    private var currentSelectedMissionConditionIndex: Int?
    
    
    override init(presenter: ConfigureMissionForAlarmPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}

extension ConfigureMissionForAlarmInteractor {
    func request(_ request: ConfigureMissionForAlarmPresenterRequest) {
        switch request {
        case .dimmedBackgroundIsTapped:
            listener?.request(.dismissScreen)
        case .addMissionButtonIsTapped:
            self.processStack.append(.selectMissionPage)
            presenter.update(.presentMissionList(items: [.shake, .tap]))
        case .missionIsSelected(let item):
            self.currentSelectedMission = item
            presenter.update(.presentMissionConditionSetting(item: item))
            
            let initialConditionIndex = 2
            self.currentSelectedMissionConditionIndex = initialConditionIndex
            presenter.update(.selecteMissionCondition(index: initialConditionIndex))
            
            self.processStack.append(.missionConditionPage)
            
        case .missionConditionIsSelected(let index):
        
            self.currentSelectedMissionConditionIndex = index
            presenter.update(.selecteMissionCondition(index: index))
            
        case .exitButtonTapped:
            // exit
            break
        case .prevButtonTapped:
            guard processStack.isEmpty == false else { preconditionFailure("UI오류발생 가능") }
            
            switch processStack.last! {
            case .selectMissionPage:
                presenter.update(.dismissMissionList)
            case .missionConditionPage:
                presenter.update(.dismissMissionConditionSetting)
            }
            _ = processStack.popLast()
            
        case .missionConditionConfirmButtonTapped:
            // save & exit
            break
        case .missionPreviewButtonTapped:
            // show preview
            break
        }
    }
}
