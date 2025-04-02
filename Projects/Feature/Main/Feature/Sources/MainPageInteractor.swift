//
//  MainPageInteractor.swift
//  FeatureMain
//
//  Created by choijunios on 1/27/25.
//

import Foundation

import FeatureDesignSystem
import FeatureAlarm
import FeatureAlarmMission
import FeatureCommonDependencies
import FeatureFortune
import FeatureAlarmRelease
import FeatureNetworking
import FeatureAlarmController

import RIBs
import RxSwift
import FirebaseRemoteConfig

public protocol MainPageActionableItem: AnyObject {
    func showAlarm(alarmId: String) -> Observable<(MainPageActionableItem, ())>
}

public enum MainPageRouterRequest {
    case routeToCreateEditAlarm(mode: AlarmCreateEditMode)
    case detachCreateEditAlarm
    case routeToAlarmMission(isFirstAlarm: Bool, missionType: AlarmMissionType)
    case detachAlarmMission((() -> Void)?)
    case routeToFortune(Fortune, UserInfo, FortuneSaveInfo)
    case detachFortune
    case routeToAlarmRelease(Alarm, Bool)
    case detachAlarmRelease((() -> Void)?)
    case presentAlertType1(DSButtonAlert.Config)
    case presentAlertType2(DSTwoButtonAlert.Config)
    case dismissAlert(completion: (()->Void)?=nil)
    case presentSettingPage
    case dismissSettingPage
}

public protocol MainPageRouting: ViewableRouting {
    func request(_ request: MainPageRouterRequest)
}

enum MainPagePresentableRequest {
    // Alarm list CRUD
    case setAlarmList(newList: [AlarmCellRO])
    case insertAlarmListElements(updateInfos: [AlarmListCellUpdateInfo])
    case deleteAlarmListElements(identifiers: [String])
    case updateAlarmListElements(updateInfos: [AlarmListCellUpdateInfo])
    
    // Single Alarm deletion
    case presentSingleAlarmDeletionView(AlarmCellRO)
    
    // Alarm list mode(idle / edit)
    case setAlarmListMode(AlarmListMode)
    case setCheckBoxStateForDeleteAllAlarms(isOn: Bool)
    case setCountForAlarmsCheckedForDeletion(countOfAlarms: Int)
    // - Single alarm deletion
    case setSingleAlarmDeltionItem(AlarmCellRO)
    case dismissSingleAlarmDeletionView
    
    // Alarm list util
    case presentAlarmListOption(isPresenting: Bool)
    
    // Orbit
    case setOrbitState(OrbitRenderState)
    
    // Fortune
    case setFortuneDeliverMark(isMarked: Bool)
    case nextFortuneDeliveryTime(text: String)
    
    // SnackBar
    case presentSnackBar(config: DSSnackBar.SnackBarConfig)
}

protocol MainPagePresentable: Presentable {
    var listener: MainPagePresentableListener? { get set }
    func request(_ request: MainPagePresentableRequest)
}

public protocol MainPageListener: AnyObject {}

final class MainPageInteractor: PresentableInteractor<MainPagePresentable>, MainPageInteractable, MainPagePresentableListener {
    // Dependency
    private let alarmController: AlarmController
    
    
    weak var router: MainPageRouting?
    weak var listener: MainPageListener?
    
    // State
    private var alarms: [String: Alarm] = [:]
    private var alarmSortType: AlarmSortType = .hourAndMinute
    
    // - OrbitState
    private var currentOrbitState: OrbitRenderState?
    
    // - 알림이 삭제를 위해 체크된 상태관리
    private var alarmSelectionInfoForDeletion: [String: Bool] = [:]
    private var alarmListMode: AlarmListMode = .idle
    private var deleteAllAlarmsChecked: Bool = false
    private var isSingleAlarmDeletionViewPresenting = false
    
    // - 알람리스트 설정
    private var isAlarmListOptionViewPresented: Bool = false
    
    // - 운세
    private var fortune: Fortune?
    private var fortuneSaveInfo: FortuneSaveInfo?
    
    
    init(
        presenter: MainPagePresentable,
        alarmController: AlarmController
    ) {
        self.alarmController = alarmController
        super.init(presenter: presenter)
        presenter.listener = self
    }
}

// MARK: - MainPageViewPresenterRequest
extension MainPageInteractor {
    func request(_ request: MainPageViewPresenterRequest) {
        switch request {
        case .viewDidLoad:
            
            // 알람 정보 업데이트
            refetchAndPresentAlarms()
            
        case .viewWillAppear:
            
            // #1. 알람 정보 업데이트
            refetchAndPresentAlarms()
            
            // #2. 오늘의 운세를 기반으로 오르비 상태 업데이트
            updateOrbitStateUsingTodayFortune()
            
            // #3. 운세도착정보 표시
            updateNextFortuneDeliveryTimeText()
            
        case .changeAlarmActivityState(let alarmId):
            guard let alarm = alarms[alarmId] else { return }
            let nextIsActiveState = !alarm.isActive
            
            let changeAlarmActivityTask = { [weak self] in
                guard let self else { return }
                // #1. 인터렉터 알람 상태 업데이트
                var newAlarm = alarm
                newAlarm.isActive = nextIsActiveState
                alarms[alarm.id] = newAlarm
                
                // #2. 영구 저장소 업데이트
                alarmController.updateAlarm(alarm: newAlarm, completion: { [weak self] result in
                    guard let self else { return }
                    if case .failure(let error) = result {
                        handle(error: error)
                    }
                })
                
                // #3. 알람 스케쥴링 상태 변경
                if nextIsActiveState == true {
                    alarmController.scheduleAlarm(alarm: newAlarm)
                } else {
                    alarmController.unscheduleAlarm(alarm: newAlarm)
                }
                
                // #4. 알람 리스트 업데이트
                let sortedAlarmList = getSorted(alarms.arr)
                if let index = sortedAlarmList.firstIndex(of: newAlarm) {
                    presenter.request(.updateAlarmListElements(
                        updateInfos: [
                            .init(
                                index: index,
                                renderObject: transform(alarm: newAlarm)
                            )
                        ]
                    ))
                }
                
                // #5. 비활성 알림이 단일알람 삭제화면의 알람일 경우
                if isSingleAlarmDeletionViewPresenting {
                    // 단일 알람 삭제화면이 표시된 경우 해당 아이템도 업데이트
                    guard let alarm = alarms[alarmId] else { return }
                    presenter.request(.setSingleAlarmDeltionItem(transform(alarm: alarm)))
                }
                
                // #6. 오르비 상태 업데이트
                updateOrbitState(fortune: fortune)
                
                // #7. 다음 운세도착시간 업데이트
                updateNextFortuneDeliveryTimeText()
                
                // #8. Alert dismissal
                router?.request(.dismissAlert())
            }
            
            let currentActiveAlarmCount = alarms.values.filter({ $0.isActive }).count
            if nextIsActiveState == false, currentActiveAlarmCount == 1 {
                // 알람을 비활성화할 때 현재 활성화된 알람의 수가 한개밖에 없는 경우
                let alertConfig: DSTwoButtonAlert.Config = .init(
                    titleText: "모든 알람 해제",
                    subTitleText: "알람을 설정하지 않으면\n운세 편지를 받을 수 없어요.",
                    leftButtonText: "취소",
                    rightButtonText: "확인",
                    leftButtonTapped: { [weak self] in
                        guard let self else { return }
                        router?.request(.dismissAlert())
                    },
                    rightButtonTapped: changeAlarmActivityTask
                )
                router?.request(.presentAlertType2(alertConfig))
                break
            } else {
                changeAlarmActivityTask()
            }
        
        case .changeAlarmListMode(let mode):
            // #1. 다중 알람 삭제 상태 초기화
            self.alarmListMode = mode
            self.alarmSelectionInfoForDeletion = [:]
            let renderObjects = transform(alarmList: getSorted(alarms.arr))
                .map { ro in
                    var newRO = ro
                    newRO.isChecked = false
                    newRO.alarmRowMode = mode
                    return newRO
                }
            self.deleteAllAlarmsChecked = false
            
            // #2. 알람 전체삭제 선택 초기화
            presenter.request(.setCheckBoxStateForDeleteAllAlarms(isOn: false))
            
            // #3. 알람리스트 업데이트
            presenter.request(.setAlarmList(newList: renderObjects))
            presenter.request(.setAlarmListMode(mode))
            presenter.request(.setCountForAlarmsCheckedForDeletion(countOfAlarms: 0))
            
            // #4. 알람리스트 옵션창 비활성화
            if isAlarmListOptionViewPresented {
                self.isAlarmListOptionViewPresented = false
                presenter.request(.presentAlarmListOption(isPresenting: false))
            }
            
        case .changeAlarmDeletionCheckState(let alarmId):
            // 체크 상태기록
            var nextState: Bool!
            if alarmSelectionInfoForDeletion[alarmId] == true {
                alarmSelectionInfoForDeletion.removeValue(forKey: alarmId)
                nextState = false
            } else {
                alarmSelectionInfoForDeletion[alarmId] = true
                nextState = true
            }
            
            // UI업데이트
            // - 알람열 업데이트
            if let alarm = alarms[alarmId] {
                let sortedAlarmList = getSorted(alarms.arr)
                if let index = sortedAlarmList.firstIndex(of: alarm) {
                    var renderObject = transform(alarm: alarm)
                    renderObject.isChecked = nextState
                    presenter.request(.updateAlarmListElements(
                        updateInfos: [.init(
                            index: index,
                            renderObject: renderObject
                        )]
                    ))
                }
            }
            
            // - 선택된 알람열 개수 업데이트
            presenter.request(.setCountForAlarmsCheckedForDeletion(
                countOfAlarms: alarmSelectionInfoForDeletion.keys.count
            ))
            
            // - 삭제될 알람으로 전체가 선택된 경우 확인
            let alarmCellCount = alarms.count
            let checkedForDeletionAlarmCount = alarmSelectionInfoForDeletion.count
            if checkedForDeletionAlarmCount == alarmCellCount, !deleteAllAlarmsChecked {
                // 단일 선택만으로 모든 알람을 선택한 경우
                self.deleteAllAlarmsChecked = true
                presenter.request(.setCheckBoxStateForDeleteAllAlarms(isOn: deleteAllAlarmsChecked))
            }
            if checkedForDeletionAlarmCount != alarmCellCount, deleteAllAlarmsChecked {
                // 단일 해제로 모든 알람 선택이 해제된 경우
                self.deleteAllAlarmsChecked = false
                presenter.request(.setCheckBoxStateForDeleteAllAlarms(isOn: deleteAllAlarmsChecked))
            }
            
        case .deleteAlarm(let alarmId):
            guard let alarm = alarms[alarmId] else { return }
            let alarmDeletionTask = { [weak self] in
                guard let self else { return }
                // #1. 인터렉터 상태 업데이트
                alarms.removeValue(forKey: alarmId)
                
                // #2. 로컬저장소 업데이트
                alarmController.removeAlarm(alarm: alarm, completion: { [weak self] result in
                    guard let self else { return }
                    if case .failure(let error) = result {
                        handle(error: error)
                    }
                })
                
                // #3. 스케쥴링된 알람 취소
                alarmController.unscheduleAlarm(alarm: alarm)
                
                // #4. UI상태 업데이트
                if alarms.isEmpty {
                    // 모든 알람을 삭제한 경우
                    presenter.request(.setAlarmList(newList: []))
                } else {
                    // 알람리스트가 비어있지 않은 경우
                    presenter.request(.deleteAlarmListElements(identifiers: [alarmId]))
                }
                
                // #5. 단일 알람삭제에서 삭제된 경우 해당 화면 닫기
                if isSingleAlarmDeletionViewPresenting {
                    self.isSingleAlarmDeletionViewPresenting = false
                    presenter.request(.dismissSingleAlarmDeletionView)
                }
                
                // #6. 다음운세 도착시간 업데이트
                updateNextFortuneDeliveryTimeText()
                
                // #7. Alert닫기
                router?.request(.dismissAlert())
            }
            let alertConfig: DSTwoButtonAlert.Config = .init(
                titleText: "알람 삭제",
                subTitleText: "삭제하시겠어요?",
                leftButtonText: "취소",
                rightButtonText: "삭제",
                leftButtonTapped: { [weak self] in
                    guard let self else { return }
                    router?.request(.dismissAlert())
                },
                rightButtonTapped: alarmDeletionTask
            )
            router?.request(.presentAlertType2(alertConfig))
            
        case .deleteSelectedAlarms:
            let alarmsDeletionTask = { [weak self] in
                guard let self else { return }
                // #1. 선택된 알람리스트 획득
                let willDeleteAlarms = alarms.values.filter { alarm in
                    self.alarmSelectionInfoForDeletion[alarm.id] == true
                }
                
                // #2. 인터렉터 상태 업데이트
                // - 삭제된 알람 배제
                willDeleteAlarms.forEach { alarm in
                    self.alarms.removeValue(forKey: alarm.id)
                }
                // - 알람리스트 상태 변경
                alarmListMode = .idle
                alarmSelectionInfoForDeletion = [:]
                
                // #3. 영구 저장소에서 알람 삭제
                alarmController.removeAlarm(alarms: willDeleteAlarms, completion: { [weak self] result in
                    guard let self else { return }
                    if case .failure(let error) = result {
                        handle(error: error)
                    }
                })
                
                // #4. 삭제될 알람 스케쥴링 해제
                willDeleteAlarms.forEach(alarmController.unscheduleAlarm)
                
                // #5. UI 업데이트
                // - 알람리스트 업데이트
                presenter.request(.setAlarmListMode(.idle))
                if alarms.isEmpty {
                    presenter.request(.setAlarmList(newList: []))
                } else {
                    let identifiers = willDeleteAlarms.map(\.id)
                    presenter.request(.deleteAlarmListElements(identifiers: identifiers))
                    
                    let sortedAlarmList = getSorted(alarms.arr)
                    presenter.request(.updateAlarmListElements(
                        updateInfos: sortedAlarmList
                            .enumerated()
                            .map { index, alarm in
                                var renderObject = self.transform(alarm: alarm)
                                renderObject.isChecked = false
                                renderObject.alarmRowMode = .idle
                                return AlarmListCellUpdateInfo(
                                    index: index,
                                    renderObject: renderObject
                                )
                            }
                    ))
                }
                // - 다음 운세도착정보 표시 업데이트
                updateNextFortuneDeliveryTimeText()
                // - Alert Dismissal
                router?.request(.dismissAlert())
                
                // #7. 복구 스낵바 표출
                let restoreDeletionTask = { [weak self] in
                    guard let self else { return }
                    // #6-1. 인터렉터 상태 복구
                    willDeleteAlarms.forEach(insertAlarm)
                    
                    // #6-2. 영구저장소 복구
                    _ = alarmController.createAlarms(alarms: willDeleteAlarms)
                    
                    // #6-3. 알람 스케쥴링 복구
                    willDeleteAlarms
                        .filter(\.isActive)
                        .forEach(alarmController.scheduleAlarm)
                    
                    // #6-4. UI업데이트
                    // - 알람 리스트 업데이트
                    let sortedAlarmList = getSorted(alarms.arr)
                    if sortedAlarmList.count == willDeleteAlarms.count {
                        // 전체삭제를 복구하는 경우
                        presenter.request(.setAlarmList(
                            newList: transform(alarmList: sortedAlarmList)
                        ))
                    } else {
                        // 일부삭제를 복구하는 경우
                        var updateInfos: [AlarmListCellUpdateInfo] = []
                        var currentIndex = 0
                        let sortedWillDeleteAlarms = getSorted(willDeleteAlarms)
                        for (index, alarm) in sortedAlarmList.enumerated() {
                            if currentIndex >= sortedWillDeleteAlarms.count { break }
                            let deletedAlarm = sortedWillDeleteAlarms[currentIndex]
                            if alarm.id == deletedAlarm.id {
                                updateInfos.append(.init(
                                    index: index,
                                    renderObject: transform(alarm: deletedAlarm)
                                ))
                                currentIndex += 1
                            }
                        }
                        presenter.request(.insertAlarmListElements(updateInfos: updateInfos))
                    }
                    // - 알람 리스트 변경
                    presenter.request(.setAlarmListMode(.idle))
                    // - 다음 운세도착정보 표시 업데이트
                    updateNextFortuneDeliveryTimeText()
                }
                let config: DSSnackBar.SnackBarConfig = .init(
                    status: .success,
                    titleText: "삭제되었어요.",
                    buttonText: "취소",
                    buttonCompletion: restoreDeletionTask
                )
                presenter.request(.presentSnackBar(config: config))
            }
       
            let alertConfig: DSTwoButtonAlert.Config = .init(
                titleText: "알람 삭제",
                subTitleText: "삭제하시겠어요?",
                leftButtonText: "취소",
                rightButtonText: "삭제",
                leftButtonTapped: { [weak self] in
                    guard let self else { return }
                    router?.request(.dismissAlert())
                },
                rightButtonTapped: alarmsDeletionTask
            )
            router?.request(.presentAlertType2(alertConfig))
            
        case .changeAllAlarmSelectionStateForDeletion:
            let prevState = deleteAllAlarmsChecked
            
            // #1. 인터렉터 상태 업데이트
            deleteAllAlarmsChecked = !prevState
            
            // #2. 상단 UI상태 업데이트
            presenter.request(.setCheckBoxStateForDeleteAllAlarms(isOn: deleteAllAlarmsChecked))
            
            // #3. 셀UI 업데이트
            if prevState == true {
                // 전체선택이 선택됬던 경우
                
                // #3-1. 인터렉터 상태 업데이트
                alarmSelectionInfoForDeletion = [:]
                
                // #3-2. UI상태 업데이트
                let renderObjects = transform(alarmList: getSorted(alarms.arr))
                    .map { ro in
                        var newRO = ro
                        newRO.isChecked = false
                        return newRO
                    }
                presenter.request(.setAlarmList(newList: renderObjects))
                presenter.request(.setCountForAlarmsCheckedForDeletion(countOfAlarms: 0))
            } else {
                // 전체선택을 실행해야하는 경우
                
                // #3-1. 인터렉터 상태 업데이트
                alarms.arr
                    .map(\.id)
                    .forEach { id in
                        self.alarmSelectionInfoForDeletion[id] = true
                    }
                
                // #3-2. UI상태 업데이트
                let renderObjects = transform(alarmList: getSorted(alarms.arr))
                    .map { ro in
                        var newRO = ro
                        newRO.isChecked = true
                        return newRO
                    }
                presenter.request(.setAlarmList(newList: renderObjects))
                presenter.request(.setCountForAlarmsCheckedForDeletion(countOfAlarms: alarmSelectionInfoForDeletion.keys.count))
            }
            
        case .checkTodayFortuneIsArrived:
            guard let fortuneInfo = UserDefaults.standard.dailyFortune() else {
                let config = DSButtonAlert.Config(
                    titleText: "받은 운세가 없어요",
                    subTitleText: """
                    알람이 울린 후 미션을 수행하면
                    오늘의 운세를 받을 수 있어요.
                    """,
                    buttonText: "닫기", buttonAction: { [weak self] in
                        guard let self else { return }
                        router?.request(.dismissAlert())
                    })
                router?.request(.presentAlertType1(config))
                return
            }
            
            let request = APIRequest.Fortune.getFortune(fortuneId: fortuneInfo.id)
            APIClient.request(Fortune.self, request: request) { [weak self] fortune in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.goToFortune(fortune: fortune, fortuneInfo: fortuneInfo)
                }
                
                // 오늘 운세는 확인된 상태로 변경
                UserDefaults.standard.setDailyFortuneChecked(isChecked: true)
                
            } failure: { error in
                print(error)
            }
            
        case .routeToSettingPage:
            router?.request(.presentSettingPage)
        case .routeToCreateAlarmPage:
            router?.request(.routeToCreateEditAlarm(mode: .create))
        case let .routeToAlarmEditPage(alarmId):
            guard let alarm = alarms[alarmId] else { return }
            if alarm.isActive { alarmController.unscheduleAlarm(alarm: alarm) }
            router?.request(.routeToCreateEditAlarm(mode: .edit(alarm)))
        case .routeToSingleAlarmDeletionView(let alarmId):
            guard let alarm = alarms[alarmId] else { break }
            self.isSingleAlarmDeletionViewPresenting = true
            presenter.request(.presentSingleAlarmDeletionView(transform(alarm: alarm)))
        case .dismissSingleAlarmDeletionView:
            self.isSingleAlarmDeletionViewPresenting = false
            presenter.request(.dismissSingleAlarmDeletionView)
        case .alarmListOptionButtonTapped:
            let isPresented = self.isAlarmListOptionViewPresented
            let nextState = !isPresented
            self.isAlarmListOptionViewPresented = nextState
            presenter.request(.presentAlarmListOption(isPresenting: nextState))
        case .screenOutsideAlarmListOptionViewTapped:
            let isPresented = self.isAlarmListOptionViewPresented
            if isPresented {
                self.isAlarmListOptionViewPresented = false
                presenter.request(.presentAlarmListOption(isPresenting: false))
            }
        }
    }
    
    private func transform(alarmList: [Alarm]) -> [AlarmCellRO] {
        alarmList.map { transform(alarm: $0) }
    }
    
    private func transform(alarm: Alarm)-> AlarmCellRO {
        let isChecked = self.alarmSelectionInfoForDeletion[alarm.id] == true
        let renderObject: AlarmCellRO = .init(
            id: alarm.id,
            isEveryWeekRepeating: {
                alarm.repeatDays.days.isEmpty == false
            }(),
            isExceptForHoliday: {
                alarm.repeatDays.shoundTurnOffHolidayAlarm
            }(),
            alarmDayText: {
                var dayDisplayText = ""
                if !alarm.repeatDays.days.isEmpty {
                    dayDisplayText = alarm.repeatDays.days
                        .map { day in
                            let orderIndex = switch day {
                            case .monday:
                                0
                            case .tuesday:
                                1
                            case .wednesday:
                                2
                            case .thursday:
                                3
                            case .friday:
                                4
                            case .saturday:
                                5
                            case .sunday:
                                6
                            }
                            return (orderIndex, day)
                        }
                        .sorted { lhs, rhs in lhs.0 < rhs.0 }
                        .map { $0.1.toShortKoreanFormat }
                        .joined(separator: ", ")
                } else {
                    var alarmHour = alarm.hour.value
                    if alarm.meridiem == .pm, (1...11).contains(alarmHour) {
                        alarmHour += 12
                    }
                    let alarmMinute = alarm.minute.value
                    let currentHour = Calendar.current.component(.hour, from: .now)
                    let currentMinute = Calendar.current.component(.minute, from: .now)
                    
                    // 알람이 현재 시간 이후에 울리는지 확인
                    let isTodayAlarm = (alarmHour > currentHour) || (alarmHour == currentHour && alarmMinute > currentMinute)
                    var alarmDate: Date = .now
                    if !isTodayAlarm {
                        // 내일 울릴 알람인 경우
                        alarmDate = Calendar.current.date(byAdding: .day, value: 1, to: .now)!
                    }
                    let month = Calendar.current.component(.month, from: alarmDate)
                    let day = Calendar.current.component(.day, from: alarmDate)
                    dayDisplayText = "\(month)월 \(day)일"
                }
                return dayDisplayText
            }(),
            meridiemText: alarm.meridiem.toKoreanFormat,
            hourAndMinuteText: String(
                format: "%d:%02d",
                alarm.hour.value,
                alarm.minute.value
            ),
            isToggleOn: alarm.isActive,
            isChecked: isChecked,
            alarmRowMode: self.alarmListMode
        )
        return renderObject
    }
    
    private func goToFortune(fortune: Fortune, fortuneInfo: FortuneSaveInfo) {
        guard let userId = Preference.userId else { return }
        APIClient.request(
            UserInfoResponseDTO.self,
            request: APIRequest.Users.getUser(userId: userId),
            success: { [weak router] userInfo in
                guard let router else { return }
                let userInfoEntity = userInfo.toUserInfo()
                DispatchQueue.main.async {
                    router.request(.routeToFortune(fortune, userInfoEntity, fortuneInfo))
                }
            }) { error in
                // 유저정보 획득 실패
                debugPrint(error.localizedDescription)
            }
    }
    
    private func checkIsFirstAlarm(with alarm: Alarm) -> Bool {
        let activeAlarmList = alarms.values.filter(\.isActive)
        let meridiem = alarm.meridiem
        if let firstAlarm = activeAlarmList
            .sorted(by: { $0.hour.to24Hour(with: meridiem) < $1.hour.to24Hour(with: meridiem) })
            .sorted(by: { $0.minute.value < $1.minute.value })
            .first { return firstAlarm.id == alarm.id }
        return false
    }
}


// MARK: - RootListenerRequest
extension MainPageInteractor {
    func reqeust(_ request: RootListenerRequest) {
        router?.request(.detachCreateEditAlarm)
        // 비즈니스 로직 업데이트
        switch request {
        case .close:
            return
        case .done(let alarm):
            // #1. 인터렉터 상태 업데이트
            insertAlarm(alarm: alarm)
            
            // #2. 영구저장소 업데이트
            alarmController.createAlarm(alarm: alarm, completion: { [weak self] result in
                guard let self else { return }
                if case .failure(let error) = result {
                    handle(error: error)
                }
            })
            
            // #3. 알람 스케쥴링
            alarmController.scheduleAlarm(alarm: alarm)
            
            // #4. 스낵바 표출
            let config: DSSnackBar.SnackBarConfig = .init(
                status: .success,
                titleText: "기상 알람이 추가되었어요."
            )
            presenter.request(.presentSnackBar(config: config))
            
        case .updated(let alarm):
            // #1. 인터렉터 상태 업데이트
            insertAlarm(alarm: alarm)
            
            // #2. 영구저장소 업데이트
            alarmController.updateAlarm(alarm: alarm, completion: { [weak self] result in
                guard let self else { return }
                if case .failure(let error) = result { handle(error: error) }
            })
            
            // #3. 알람 스케쥴링
            if alarm.isActive { alarmController.scheduleAlarm(alarm: alarm) }
            
        case .deleted(let alarm):
            // #1. 인터렉터 상태 업데이트
            alarms.removeValue(forKey: alarm.id)
            
            // #2. 영구저장소 업데이트
            alarmController.removeAlarm(alarm: alarm, completion: { [weak self] result in
                guard let self else { return }
                if case .failure(let error) = result { handle(error: error) }
            })
            
            // #3. UI업데이트
            if alarms.count == 0 {
                presenter.request(.setAlarmList(newList: []))
            } else {
                presenter.request(.deleteAlarmListElements(identifiers: [alarm.id]))
            }
        }
        
        // 다음 운세도착정보 표시 업데이트
        updateNextFortuneDeliveryTimeText()
        
        // UI업데이트
        let renderObjects = transform(alarmList: getSorted(alarms.arr))
        presenter.request(.setAlarmList(newList: renderObjects))
    }
}


// MARK: ShakeMissionMainListener
extension MainPageInteractor {
    func request(_ request: FeatureAlarmMission.AlarmMissionRootListenerRequest) {
        switch request {
        case let .missionCompleted(fortune, fortuneInfo):
            router?.request(.detachAlarmMission { [weak self] in
                guard let self else { return }
                goToFortune(fortune: fortune, fortuneInfo: fortuneInfo)
            })
        case let .close(fortune, fortuneInfo):
            router?.request(.detachAlarmMission { [weak self] in
                guard let self else { return }
                guard let fortune, let fortuneInfo else { return }
                goToFortune(fortune: fortune, fortuneInfo: fortuneInfo)
            })
        }
    }
}


// MARK: - FortuneListenerRequest
extension MainPageInteractor {
    func request(_ request: FeatureFortune.FortuneListenerRequest) {
        switch request {
        case .close:
            // 운세페이지를 닫을 경우 읽음 처리
            UserDefaults.standard.setDailyFortuneChecked(isChecked: true)
            
            // 운세페이지 종료
            router?.request(.detachFortune)
        }
    }
}

extension MainPageInteractor {
    func request(_ request: FeatureAlarmRelease.AlarmReleaseIntroListenerRequest) {
        switch request {
        case let .releaseAlarm(isFirstAlarm):
            router?.request(.detachAlarmRelease({ [weak self] in
                guard let self else { return }
                let config = RemoteConfig.remoteConfig()
                let configValue = config["alarm_mission_type"].stringValue
                debugPrint("Remote config에서 획득한 미션타입: \(configValue)")
                let mission = AlarmMissionType(key: configValue)
                router?.request(.routeToAlarmMission(
                    isFirstAlarm: isFirstAlarm,
                    missionType: mission
                ))
            }))
        }
    }
}

extension MainPageInteractor: MainPageActionableItem {
    func showAlarm(alarmId: String) -> Observable<(MainPageActionableItem, ())> {
        guard let alarm = alarms[alarmId] else { return .just((self, ())) }
        let isFirstAlarm = self.checkIsFirstAlarm(with: alarm)
        router?.request(.routeToAlarmRelease(alarm, isFirstAlarm))
        return .just((self, ()))
    }
}


// MARK: Update Alarm
private extension MainPageInteractor {
    func insertAlarm(alarm: Alarm) {
        let key = alarm.id
        self.alarms[key] = alarm
    }
    
    func insertAlarms(alarms: [Alarm]) {
        alarms.forEach { insertAlarm(alarm: $0) }
    }
    
    func clearAlarms() {
        alarms.removeAll()
    }
    
    func getSorted(_ alarms: [Alarm]) -> [Alarm] {
        alarms.sorted(by: alarmSortType.compare(direction: .ascending))
    }
}


// MARK: SettingMainListener
extension MainPageInteractor {
    func dismiss() {
        router?.request(.dismissSettingPage)
    }
}


// MARK: Find next fortune alarm date
private extension MainPageInteractor {
    func updateNextFortuneDeliveryTimeText() {
        // 운세도착정보 표시
        let nextFortuneAlarm = findNextFortuneAlarmDate()
        let nextFortuneDeliveryTimeText = getAlarmingText(alarm: nextFortuneAlarm)
        presenter.request(.nextFortuneDeliveryTime(text: nextFortuneDeliveryTimeText))
    }
    
    func getAlarmingText(alarm: Alarm?) -> String {
        let defaultText = "받을 수 있는 운세가 없어요"
        guard let alarm else { return defaultText }
        
        let calendar = Calendar.current
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: .now)
        
        guard let components = alarm.earliestDateComponent() else { return defaultText }
        let hourAndMinute = String(format: "%d:%02d", alarm.hour.value, alarm.minute.value)
        let yearStr = String(components.year!).suffix(2)
        let month = components.month!
        let day = components.day!
        let meridiemText = alarm.meridiem.toKoreanFormat
        
        // 울리는 알람이 오늘인가?
        let isToday = components.year == todayComponents.year &&
        components.month == todayComponents.month &&
        components.day == todayComponents.day
        
        if isToday {
            return "\(meridiemText) \(hourAndMinute) 도착"
        }
        
        
        // 울리는 알람이 내일인가?
        let nextDay = calendar.date(byAdding: .day, value: 1, to: .now)!
        let nextDayComponents = calendar.dateComponents([.year, .month, .day], from: nextDay)
        let isTommorrow = components.year == nextDayComponents.year &&
        components.month == nextDayComponents.month &&
        components.day == nextDayComponents.day
        
        if isTommorrow {
            return "내일 \(meridiemText) \(hourAndMinute) 도착"
        }
        
        
        // 다른날 도착하는 알람
        
        // 해가 넘어갔는가?
        if components.year! > todayComponents.year! {
            let dateText = "\(yearStr)년 \(month)월 \(day)일"
            return "\(dateText) \(meridiemText) \(hourAndMinute) 도착"
        } else {
            // 해가 넘어가지 않은 경우
            let dateText = "\(month)월 \(day)일"
            return "\(dateText) \(meridiemText) \(hourAndMinute) 도착"
        }
    }
    
    
    func findNextFortuneAlarmDate() -> Alarm? {
        if alarms.values.filter(\.isActive).isEmpty {
            // 활성화 알람이 없는 경우
            return nil
        }
        let calendar = Calendar.current
        let alarmsAndDates = self.alarms.values
            .filter(\.isActive)
            .compactMap { alarm -> (Alarm, Date)? in
                guard let components = alarm.earliestDateComponent(),
                      let alarmDate = calendar.date(from: components) else { return nil }
                return (alarm, alarmDate)
            }
            .sorted { lhs, rhs in lhs.1 < rhs.1 }
        
        
        let firstAlarm = alarmsAndDates.first!
        
        if UserDefaults.standard.dailyFortune() == nil {
            // 오늘 첫번째 알람이 도착하지 않은 경우, 가장 처음 울리는 알람을 반환
            return firstAlarm.0
        } else {
            // 오늘 운세가 확인된 경우 -> 내일 이후 도착할 알람중 첫번째를 찾는다.
            let nextDay = calendar.date(byAdding: .day, value: 1, to: .now)!
            let nextDayComponents = calendar.dateComponents([.year, .month, .day], from: nextDay)
            return self.alarms.values
                .filter(\.isActive)
                .compactMap { alarm -> (Alarm, Date)? in
                    guard let components = alarm.earliestDateComponent(),
                          let alarmDate = calendar.date(from: components) else { return nil }
                    if components.year! >= nextDayComponents.year!,
                       components.month! >= nextDayComponents.month!,
                       components.day! >= nextDayComponents.day! {
                        // 내일 이후 알람만 반환
                        return (alarm, alarmDate)
                    }
                    return nil
                }
                .sorted { lhs, rhs in lhs.1 < rhs.1 }
                .first?.0
        }
    }
}


// MARK: Orbit state
private extension MainPageInteractor {
    func getOrbitState(fortune checkingFortune: Fortune?) -> OrbitRenderState {
        guard alarms.values.filter(\.isActive).isEmpty == false else { return .emptyAlarm }
        guard let checkingFortune, let userInfo = Preference.userInfo else { return .beforeFortune }
        let userName = userInfo.name
        var orbitState: OrbitRenderState!
        switch checkingFortune.avgFortuneScore {
        case 0..<50:
            orbitState = .luckScoreOverZero(userName: userName)
        case 50..<80:
            orbitState = .luckScoreOver50(userName: userName)
        case 80...:
            orbitState = .luckScoreOver80(userName: userName)
        default:
            orbitState = .beforeFortune
        }
        return orbitState
    }
    
    func updateOrbitState(fortune: Fortune? = nil) {
        let newState = getOrbitState(fortune: fortune)
        if newState != currentOrbitState {
            self.currentOrbitState = newState
            presenter.request(.setOrbitState(newState))
        }
    }
    
    func updateOrbitStateUsingTodayFortune() {
        
        // 유저정보와 운세정보를 확인하여 오르빗 상태 업데이트
        if let todayFortuneInfo = UserDefaults.standard.dailyFortune() {
            self.fortuneSaveInfo = todayFortuneInfo
            
            // 오늘의 운세가 있는 경우
            if fortuneSaveInfo == todayFortuneInfo, let fortune {
                // 메모리에 운세가 있는 경우
                updateOrbitState(fortune: fortune)
                return
            }
            
            // API요청을 통해 운세획득
            let isDailyForuneIsChecked = UserDefaults.standard.dailyFortuneIsChecked()
            if isDailyForuneIsChecked {
                // 오늘 운세가 확인된 경우
                presenter.request(.setFortuneDeliverMark(isMarked: false))
                
                // 오늘 운세가 확인된 경우, API를 통해 점수를 확인
                let fortuneId = todayFortuneInfo.id
                let request = APIRequest.Fortune.getFortune(fortuneId: fortuneId)
                APIClient.request(Fortune.self, request: request) { [weak self] fetchedFortune in
                    guard let self else { return }
                    updateOrbitState(fortune: fetchedFortune)
                    self.fortune = fetchedFortune
                } failure: { error in
                    print(error)
                }
            } else {
                // 오늘 운세가 확인되지 않은 경우, 편지함에 빨간점 추가
                presenter.request(.setFortuneDeliverMark(isMarked: true))
            }
        } else {
            // 운세가 없는 경우
            updateOrbitState(fortune: nil)
            presenter.request(.setFortuneDeliverMark(isMarked: false))
        }
    }
}


// MARK: Refetch alarms
private extension MainPageInteractor {
    func refetchAndPresentAlarms() {
        let alarmFetchResult = alarmController.readAlarms()
        switch alarmFetchResult {
        case .success(let fetchedAlarms):
            // #1. 인터렉터 상태 업데이트
            clearAlarms()
            insertAlarms(alarms: fetchedAlarms)
            
            // #2. UI업데이트
            let renderObjects = transform(alarmList: getSorted(fetchedAlarms))
            presenter.request(.setAlarmList(newList: renderObjects))
        case .failure(let error):
            debugPrint("Error, \(error.localizedDescription)")
            handle(error: error)
        }
    }
}


// MARK: Handle alarmController error
private extension MainPageInteractor {
    func handle(error: AlarmControllerError) {
        let config = DSButtonAlert.Config(
            titleText: "알람 설정 오류",
            subTitleText: error.message,
            buttonText: "닫기",
            buttonAction: { [weak self] in
                guard let self else { return }
                router?.request(.dismissAlert(completion: nil))
            }
        )
        router?.request(.presentAlertType1(config))
    }
}


fileprivate extension Dictionary {
    var arr: [Value] { Array(self.values) }
}
