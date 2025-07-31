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
    case present(page: PagePresentation)
    case selectMissionCondition(index: Int)
}

enum PagePresentation {
    case currentMissionPage(item: MissionItemRenderObject, conditionIndex: Int)
    case missionConditionSettingPage(item: MissionItemRenderObject, conditionIndex: Int)
    case missionListPage(items: [MissionItemRenderObject])
    case addMissionPage
}

public protocol ConfigureMissionForAlarmListener: AnyObject {
    func request(_ request: ConfigureMissionForAlarmListenerRequest)
}

public enum ConfigureMissionForAlarmListenerRequest {
    case missionSelected(Mission)
    case missionIsRemoved
    case dismissScreen
}

final class ConfigureMissionForAlarmInteractor: PresentableInteractor<ConfigureMissionForAlarmPresentable>, ConfigureMissionForAlarmInteractable, ConfigureMissionForAlarmPresentableListener {

    weak var router: ConfigureMissionForAlarmRouting?
    weak var listener: ConfigureMissionForAlarmListener?

    
    // State
    // - Navigation
    private var pageStack: [Page] = [] {
        didSet {
            print(pageStack)
        }
    }
    
    // - Mission
    private let missionListItems: [MissionItemRenderObject] = [.shake, .tap]
    private var currentSelectedMission: MissionItemRenderObject?
    private var currentSelectedMissionConditionIndex: Int?
    
    
    private let initialMission: Mission?
    
    init(presenter: ConfigureMissionForAlarmPresentable, initialMission: Mission?) {
        self.initialMission = initialMission
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // 초기 미션 설정
        presentInitialPage(mission: initialMission)
    }
    
    func presentInitialPage(mission: Mission?) {
        if let mission {
            // 설정된 미션이 있는 경우
            
            let (renderObject, conditionIndex) = convertMissionToRenderObject(mission)
            currentSelectedMission = renderObject
            currentSelectedMissionConditionIndex = conditionIndex
            
            // 기존에 선택된 미션이 있는 경우 바로 미션 조건 설정 화면으로 진입
            pageStack.append(.currentMissionPage)
            presenter.update(.present(page: .currentMissionPage(
                item: renderObject, conditionIndex: conditionIndex)
            ))
        } else {
            // 설정된 미션이 없는 경우
            pageStack.append(.addMissionPage)
            presenter.update(.present(page: .addMissionPage))
        }
    }
}

extension ConfigureMissionForAlarmInteractor {
    func request(_ request: ConfigureMissionForAlarmPresenterRequest) {
        switch request {
        case .dimmedBackgroundIsTapped:
            
            listener?.request(.dismissScreen)
            
        case .addMissionButtonIsTapped:
            
            self.pageStack.append(.missionListPage)
            presenter.update(.present(page: .missionListPage(items: missionListItems)))
            
        case .missionChangeButtonTapped:
            
            self.pageStack.append(.missionListPage)
            presenter.update(.present(page: .missionListPage(items: missionListItems)))
            
        case .missionDeleteButtonTapped:
            
            currentSelectedMission = nil
            currentSelectedMissionConditionIndex = nil
            
            listener?.request(.missionIsRemoved)
            pageStack = [.addMissionPage]
            presenter.update(.present(page: .addMissionPage))
            
        case .missionIsSelected(let item):
            
            let initialConditionIndex = 2
            
            self.currentSelectedMission = item
            self.currentSelectedMissionConditionIndex = initialConditionIndex
            
            presenter.update(.present(page: .missionConditionSettingPage(
                item: item,
                conditionIndex: initialConditionIndex)
            ))
            
            self.pageStack.append(.missionConditionSettingPage)
            
        case .missionConditionIsSelected(let index):
        
            self.currentSelectedMissionConditionIndex = index
            presenter.update(.selectMissionCondition(index: index))
            
        case .exitButtonTapped:
            
            listener?.request(.dismissScreen)
            
        case .prevButtonTapped:
            
            guard pageStack.isEmpty == false else { preconditionFailure("UI오류발생 가능") }
            
            pageStack.removeLast()
            
            guard pageStack.isEmpty == false else { return }
            
            switch pageStack.last! {
            case .addMissionPage, .currentMissionPage:
                if let currentSelectedMission, let currentSelectedMissionConditionIndex {
                    self.pageStack = [.currentMissionPage]
                    presenter.update(.present(page: .currentMissionPage(
                        item: currentSelectedMission,
                        conditionIndex: currentSelectedMissionConditionIndex)
                    ))
                } else {
                    self.pageStack = [.addMissionPage]
                    presenter.update(.present(page: .addMissionPage))
                }
            case .missionListPage:
                presenter.update(.present(page: .missionListPage(items: missionListItems)))
            case .missionConditionSettingPage:
                preconditionFailure("해당 플로우 없음")
            }
            
        case .missionSaveButtonTapped:
            
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
            if let selectedMission = currentSelectedMission, let countIndex = currentSelectedMissionConditionIndex {
                let mission: Mission
                let countItem = selectedMission.conditionItems[countIndex]
                switch selectedMission {
                case .shake:
                    mission = .init(type: .shake, count: countItem.value)
                case .tap:
                    mission = .init(type: .tap, count: countItem.value)
                }
                router?.routeToMissionPreview(mission: mission, isPreviewMode: true)
            }
            
        case .missionConditionChangeButtonTapped:
            
            guard let mission = initialMission else { preconditionFailure("해당 플로우 없음") }
            let (renderObject, conditionIndex) = convertMissionToRenderObject(mission)
            
            pageStack.append(.missionConditionSettingPage)
            presenter.update(.present(page: .missionConditionSettingPage(
                item: renderObject,
                conditionIndex: conditionIndex
            )))
            
        case .missionCompleteButtonTapped:
            
            listener?.request(.dismissScreen)
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
