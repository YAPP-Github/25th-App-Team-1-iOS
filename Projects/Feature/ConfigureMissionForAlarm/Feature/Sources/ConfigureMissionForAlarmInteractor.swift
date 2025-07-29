//
//  ConfigureMissionForAlarmInteractor.swift
//  FeatureConfigureMissionForAlarm
//
//  Created by choijunios on 7/21/25.
//

import RIBs
import RxSwift
import FeatureCommonEntity
import FeatureAlarmMission

public protocol ConfigureMissionForAlarmRouting: ViewableRouting {
    func routeToMissionPreview(mission: Mission, isPreviewMode: Bool)
    func detachMissionPreview()
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
    case updateMissionDisplay(item: MissionItemRenderObject, conditionIndex: Int)
    case showDefaultUIAfterMissionDelete
}

public protocol ConfigureMissionForAlarmListener: AnyObject {
    func request(_ request: ConfigureMissionForAlarmListenerRequest)
}

public enum ConfigureMissionForAlarmListenerRequest {
    case missionSelected(Mission)
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
    
    
    private let initialMission: Mission
    
    init(presenter: ConfigureMissionForAlarmPresentable, initialMission: Mission) {
        self.initialMission = initialMission
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // 초기 미션 설정
        let (renderObject, conditionIndex) = convertMissionToRenderObject(initialMission)
        currentSelectedMission = renderObject
        currentSelectedMissionConditionIndex = conditionIndex
        
        // 기존에 선택된 미션이 있는 경우 바로 미션 조건 설정 화면으로 진입
        presenter.update(.updateMissionDisplay(item: renderObject, conditionIndex: conditionIndex))
        presenter.update(.presentMissionConditionSetting(item: renderObject))
        presenter.update(.selecteMissionCondition(index: conditionIndex))
        processStack.append(.missionConditionPage)
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
        case .missionChangeButtonTapped:
            // 미션 변경 버튼을 누른 경우 미션 선택 화면으로 이동
            self.processStack.append(.selectMissionPage)
            presenter.update(.presentMissionList(items: [.shake, .tap]))
        case .missionDeleteButtonTapped:
            // 미션 삭제 버튼을 누른 경우 기본 UI로 전환
            currentSelectedMission = nil
            currentSelectedMissionConditionIndex = nil
            processStack.removeAll()
            presenter.update(.showDefaultUIAfterMissionDelete)
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
            listener?.request(.dismissScreen)
            
        case .prevButtonTapped:
            guard processStack.isEmpty == false else { preconditionFailure("UI오류발생 가능") }
            
            switch processStack.last! {
            case .selectMissionPage:
                presenter.update(.dismissMissionList)
            case .missionConditionPage:
                // 미션 조건 설정 화면에서 뒤로 가기
                if processStack.count == 1 {
                    // 초기 미션이 있어서 바로 조건 설정으로 진입한 경우 화면 닫기
                    listener?.request(.dismissScreen)
                    return
                } else {
                    // 미션 선택 화면으로 돌아가기
                    presenter.update(.dismissMissionConditionSetting)
                }
            }
            _ = processStack.popLast()
            
        case .missionConditionConfirmButtonTapped:
            // save
            if let selectedMission = currentSelectedMission,
               let selectedConditionIndex = currentSelectedMissionConditionIndex {
                let mission = convertToMission(renderObject: selectedMission, conditionIndex: selectedConditionIndex)
                listener?.request(.missionSelected(mission))
                return
            }
            listener?.request(.dismissScreen)
        case .missionPreviewButtonTapped:
            // show preview
            if let selectedMission = currentSelectedMission, let count = currentSelectedMissionConditionIndex {
                let mission: Mission
                switch selectedMission {
                case .shake:
                    mission = .init(type: .shake, count: count)
                case .tap:
                    mission = .init(type: .tap, count: count)
                }
                router?.routeToMissionPreview(mission: mission, isPreviewMode: true)
            }
        }
    }
    
    private func convertToMission(renderObject: MissionItemRenderObject, conditionIndex: Int) -> Mission {
        let missionType: Mission.MissionType
        switch renderObject {
        case .shake:
            missionType = .shake
        case .tap:
            missionType = .tap
        }
        
        let count = renderObject.conditionItems[conditionIndex].value
        return Mission(type: missionType, count: count)
    }
    
    private func convertMissionToRenderObject(_ mission: Mission) -> (MissionItemRenderObject, Int) {
        let renderObject: MissionItemRenderObject
        switch mission.type {
        case .shake:
            renderObject = .shake
        case .tap:
            renderObject = .tap
        }
        
        // conditionItems에서 count와 일치하는 인덱스 찾기
        let conditionIndex = renderObject.conditionItems.firstIndex { $0.value == mission.count } ?? 2 // 기본값 2 (15회)
        
        return (renderObject, conditionIndex)
    }
}

// MARK: - AlarmMissionRootListener
extension ConfigureMissionForAlarmInteractor {
    func request(_ request: AlarmMissionRootListenerRequest) {
        switch request {
        case .missionCompleted, .close:
            router?.detachMissionPreview()
        }
    }
}
