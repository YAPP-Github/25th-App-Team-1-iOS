//
//  MainPageInteractor.swift
//  FeatureMain
//
//  Created by choijunios on 1/27/25.
//

import Foundation
import RIBs
import RxSwift
import FeatureDesignSystem
import FeatureAlarm
import FeatureAlarmMission
import FeatureCommonDependencies
import FeatureFortune
import FeatureAlarmRelease
import FeatureNetworking
import FeatureAlarmController

public protocol MainPageActionableItem: AnyObject {
    func showAlarm(alarmId: String) -> Observable<(MainPageActionableItem, ())>
}

public enum MainPageRouterRequest {
    case routeToCreateEditAlarm(mode: AlarmCreateEditMode)
    case detachCreateEditAlarm
    case routeToAlarmMission(Bool)
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
    case setAlarmList([AlarmCellRO])
    case setAlarmListMode(AlarmListMode)
    case setCountForAlarmsCheckedForDeletion(countOfAlarms: Int)
    case presentSnackBar(config: DSSnackBar.SnackBarConfig)
    case setFortuneDeliverMark(isMarked: Bool)
    case nextFortuneDeliveryTime(text: String)
    case setOrbitState(OrbitRenderState)
    case setCheckForDeleteAllAlarms(isOn: Bool)
    case presentSingleAlarmDeletionView(AlarmCellRO)
    case dismissSingleAlarmDeletionView
    case setSingleAlarmDeltionItem(AlarmCellRO)
    case presentAlarmListOption(isPresenting: Bool)
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
    private var alarmRenderObjects: [String: AlarmCellRO] = [:]
    private var alarmSortType: AlarmSortType = .hourAndMinute
    
    // - OrbitState
    private var currentOrbitState: OrbitRenderState?
    
    // - 알림이 삭제를 위해 체크된 상태관리
    private var checkedState: [String: Bool] = [:]
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
            // 알람 정보 업데이트
            refetchAndPresentAlarms()
            
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
            
            // 운세도착정보 표시
            updateNextFortuneDeliveryTimeText()

        case .showFortuneNoti:
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
            
        case .goToSettings:
            router?.request(.presentSettingPage)
        case .createAlarm:
            router?.request(.routeToCreateEditAlarm(mode: .create))
        case let .editAlarm(alarmId):
            guard let alarm = alarms[alarmId] else { return }
            if alarm.isActive { alarmController.unscheduleAlarm(alarm: alarm) }
            router?.request(.routeToCreateEditAlarm(mode: .edit(alarm)))
        case let .changeAlarmActivityState(alarmId):
            guard var alarm = alarms[alarmId] else { return }
            let nextState = !alarm.isActive
            
            let changeAlarmActivity = { [weak self] in
                guard let self else { return }
                // 로직 업데이트
                alarm.isActive = nextState
                
                
                // 알람 스케쥴링 변경
                if nextState == true {
                    alarmController.scheduleAlarm(alarm: alarm)
                } else {
                    alarmController.unscheduleAlarm(alarm: alarm)
                }
                
                
                self.alarms[alarm.id] = alarm
                alarmController.updateAlarm(alarm: alarm, completion: nil)
                
                // 알람 리스트 업데이트(토들)
                self.alarmRenderObjects[alarm.id] = transform(alarm: alarm)
                presenter.request(.setAlarmList(getSorted(ros: alarmRenderObjects.values.map({$0}))))
                
                if self.isSingleAlarmDeletionViewPresenting {
                    // 단일 알람 삭제화면이 표시된 경우 해당 아이템도 업데이트
                    guard let alarm = alarms[alarmId] else { return }
                    presenter.request(.setSingleAlarmDeltionItem(transform(alarm: alarm)))
                }
                
                
                // 오르비 상태 업데이트
                updateOrbitState(fortune: fortune)
                
                
                // 다음 운세도착정보 표시 업데이트
                updateNextFortuneDeliveryTimeText()
            }
            
            let currentActiveAlarmCount = alarms.values.filter({ $0.isActive }).count
            if nextState == false, currentActiveAlarmCount == 1 {
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
                    rightButtonTapped: { [weak self] in
                        guard let self else { return }
                        changeAlarmActivity()
                        router?.request(.dismissAlert())
                    }
                )
                router?.request(.presentAlertType2(alertConfig))
                break
            } else {
                changeAlarmActivity()
            }
        case let .deleteAlarm(alarmId):
            guard let alarm = alarms[alarmId] else { return }
            let alertConfig: DSTwoButtonAlert.Config = .init(
                titleText: "알람 삭제",
                subTitleText: "삭제하시겠어요?",
                leftButtonText: "취소",
                rightButtonText: "삭제",
                leftButtonTapped: { [weak self] in
                    guard let self else { return }
                    router?.request(.dismissAlert())
                },
                rightButtonTapped: { [weak self] in
                    guard let self else { return }
                    // 로컬저장소 업데이트
                    alarmController.removeAlarm(alarm: alarm, completion: nil)
                    alarmController.unscheduleAlarm(alarm: alarm)
                    
                    // 상태업데이트
                    alarms.removeValue(forKey: alarmId)
                    
                    // 랜더오브젝트 상태 업데이트
                    alarmRenderObjects.removeValue(forKey: alarmId)
                    
                    presenter.request(.setAlarmList(getSorted(ros: alarmRenderObjects.values.map({$0}))))
                    
                    // Single alarm deletion뷰로 삭제중일 경우
                    if isSingleAlarmDeletionViewPresenting {
                        self.isSingleAlarmDeletionViewPresenting = false
                        presenter.request(.dismissSingleAlarmDeletionView)
                    }
                    
                    // 다음 운세도착정보 표시 업데이트
                    updateNextFortuneDeliveryTimeText()
                    
                    router?.request(.dismissAlert())
                }
            )
            router?.request(.presentAlertType2(alertConfig))
            
        case .changeAlarmListMode(let mode):
            self.alarmListMode = mode
            self.checkedState = [:]
            
            alarmRenderObjects.keys.forEach { alarmCellROKey in
                alarmRenderObjects[alarmCellROKey]?.isChecked = false
                alarmRenderObjects[alarmCellROKey]?.mode = mode
            }
            
            self.deleteAllAlarmsChecked = false
            presenter.request(.setCheckForDeleteAllAlarms(isOn: false))
            presenter.request(.setAlarmList(getSorted(ros: alarmRenderObjects.values.map({$0}))))
            presenter.request(.setAlarmListMode(mode))
            presenter.request(.setCountForAlarmsCheckedForDeletion(countOfAlarms: 0))
            if isAlarmListOptionViewPresented {
                self.isAlarmListOptionViewPresented = false
                presenter.request(.presentAlarmListOption(isPresenting: false))
            }
        case .changeAlarmCheckState(let alarmId):
            // 체크 상태기록
            var nextState: Bool!
            if self.checkedState[alarmId] == true {
                self.checkedState.removeValue(forKey: alarmId)
                nextState = false
            } else {
                self.checkedState[alarmId] = true
                nextState = true
            }
            
            // UI업데이트
            alarmRenderObjects[alarmId]?.isChecked = nextState
            presenter.request(.setAlarmList(getSorted(ros: alarmRenderObjects.values.map({$0}))))
            presenter.request(.setCountForAlarmsCheckedForDeletion(
                countOfAlarms: self.checkedState.keys.count
            ))
            
            let alarmCellCount = alarmRenderObjects.count
            let checkedForDeletionAlarmCount = checkedState.count
            if checkedForDeletionAlarmCount == alarmCellCount, !deleteAllAlarmsChecked {
                // 단일 선택으로 모든 알람을 선택한 경우
                self.deleteAllAlarmsChecked = true
                presenter.request(.setCheckForDeleteAllAlarms(isOn: deleteAllAlarmsChecked))
            }
            if checkedForDeletionAlarmCount != alarmCellCount, deleteAllAlarmsChecked {
                // 단일 해제로 모든 알람 선택이 해제된 경우
                self.deleteAllAlarmsChecked = false
                presenter.request(.setCheckForDeleteAllAlarms(isOn: deleteAllAlarmsChecked))
            }
            
        case .deleteAlarms:
            let alertConfig: DSTwoButtonAlert.Config = .init(
                titleText: "알람 삭제",
                subTitleText: "삭제하시겠어요?",
                leftButtonText: "취소",
                rightButtonText: "삭제",
                leftButtonTapped: { [weak self] in
                    guard let self else { return }
                    router?.request(.dismissAlert())
                },
                rightButtonTapped: { [weak self] in
                    guard let self else { return }
                    router?.request(.dismissAlert())
                    
                    // 비즈니스 로직
                    let willDeleteAlarms = alarms.values.filter { alarm in
                        self.checkedState[alarm.id] == true
                    }
                    alarmController.removeAlarm(alarms: willDeleteAlarms, completion: nil)
                    willDeleteAlarms.forEach { alarm in
                        self.alarmController.unscheduleAlarm(alarm: alarm)
                        self.alarms.removeValue(forKey: alarm.id)
                        self.alarmRenderObjects.removeValue(forKey: alarm.id)
                    }
                    
                    // UI 업데이트
                    alarmRenderObjects.values.forEach { alarmRO in
                        if self.checkedState[alarmRO.id] != true {
                            self.alarmRenderObjects[alarmRO.id]?.mode = .idle
                            self.alarmRenderObjects[alarmRO.id]?.isChecked = false
                        }
                    }
                    self.checkedState = [:]
                    self.alarmListMode = .idle
                    presenter.request(.setAlarmListMode(.idle))
                    presenter.request(.setAlarmList(getSorted(ros: alarmRenderObjects.values.map({$0}))))
                    presenter.request(.setCountForAlarmsCheckedForDeletion(countOfAlarms: 0))
                    
                    // 다음 운세도착정보 표시 업데이트
                    updateNextFortuneDeliveryTimeText()
                    
                    let config: DSSnackBar.SnackBarConfig = .init(
                        status: .success,
                        titleText: "삭제되었어요.",
                        buttonText: "취소",
                        buttonCompletion: { [weak self] in
                            guard let self else { return }
                            _ = self.alarmController.createAlarms(alarms: willDeleteAlarms)
                            willDeleteAlarms.forEach { alarm in
                                // 복구
                                if alarm.isActive { self.alarmController.scheduleAlarm(alarm: alarm) }
                                self.insertAlarm(alarm: alarm)
                                self.insertAlarmRO(ro: self.transform(alarm: alarm))
                            }
                            
                            // 다음 운세도착정보 표시 업데이트
                            updateNextFortuneDeliveryTimeText()
                            
                            // UI업데이트
                            presenter.request(.setAlarmList(getSorted(ros: alarmRenderObjects.values.map({$0}))))
                        }
                    )
                    presenter.request(.presentSnackBar(config: config))
                    
                }
            )
            router?.request(.presentAlertType2(alertConfig))
            
        case .checkAllAlarmForDeletionButtonTapped:
            let prevState = deleteAllAlarmsChecked
            if prevState == true {
                // 전체선택 해제
                alarmRenderObjects.values.forEach { alarmRO in
                    alarmRenderObjects[alarmRO.id]?.isChecked = false
                }
                self.checkedState = [:]
                presenter.request(.setAlarmList(getSorted(ros: alarmRenderObjects.values.map({$0}))))
                presenter.request(.setCountForAlarmsCheckedForDeletion(countOfAlarms: 0))
            } else {
                // 전체선택
                alarmRenderObjects.values.forEach { alarmRO in
                    alarmRenderObjects[alarmRO.id]?.isChecked = true
                    checkedState[alarmRO.id] = true
                }
                presenter.request(.setAlarmList(getSorted(ros: alarmRenderObjects.values.map({$0}))))
                presenter.request(.setCountForAlarmsCheckedForDeletion(
                    countOfAlarms: self.checkedState.keys.count
                ))
            }
            self.deleteAllAlarmsChecked = !prevState
            presenter.request(.setCheckForDeleteAllAlarms(isOn: deleteAllAlarmsChecked))
            
        case .presentSingleAlarmDeletionView(let alarmId):
            guard let alarmRO = alarmRenderObjects[alarmId] else { break }
            self.isSingleAlarmDeletionViewPresenting = true
            presenter.request(.presentSingleAlarmDeletionView(alarmRO))
        case .dismissSingleAlarmDeletionView:
            self.isSingleAlarmDeletionViewPresenting = false
            presenter.request(.dismissSingleAlarmDeletionView)
        case .alarmOptionButtonTapped:
            let isPresented = self.isAlarmListOptionViewPresented
            let nextState = !isPresented
            self.isAlarmListOptionViewPresented = nextState
            presenter.request(.presentAlarmListOption(isPresenting: nextState))
        case .screenWithoutAlarmOptionViewTapped:
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
        let isChecked = self.checkedState[alarm.id] == true
        return AlarmCellRO(
            id: alarm.id,
            alarmDays: alarm.repeatDays,
            meridiem: alarm.meridiem,
            hour: alarm.hour,
            minute: alarm.minute,
            isToggleOn: alarm.isActive,
            isChecked: isChecked,
            mode: self.alarmListMode
        )
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
        case let .done(alarm):
            alarmController.createAlarm(alarm: alarm, completion: nil)
            alarmController.scheduleAlarm(alarm: alarm)
            insertAlarm(alarm: alarm)
            insertAlarmRO(ro: transform(alarm: alarm))
            let config: DSSnackBar.SnackBarConfig = .init(
                status: .success,
                titleText: "기상 알람이 추가되었어요."
            )
            presenter.request(.presentSnackBar(config: config))
            
        case let .updated(alarm):
            alarmController.updateAlarm(alarm: alarm, completion: nil)
            if alarm.isActive { alarmController.scheduleAlarm(alarm: alarm) }
            insertAlarm(alarm: alarm)
            insertAlarmRO(ro: transform(alarm: alarm))
        case let .deleted(alarm):
            alarmController.removeAlarm(alarm: alarm, completion: nil)
            alarms.removeValue(forKey: alarm.id)
            alarmRenderObjects.removeValue(forKey: alarm.id)
        }
        
        // 다음 운세도착정보 표시 업데이트
        updateNextFortuneDeliveryTimeText()
        
        // UI업데이트
        presenter.request(.setAlarmList(getSorted(ros: alarmRenderObjects.values.map({$0}))))
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
            router?.request(.detachAlarmRelease({ [weak router] in
                router?.request(.routeToAlarmMission(isFirstAlarm))
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
    
    
    func insertAlarmRO(ro: AlarmCellRO) {
        let key = ro.id
        self.alarmRenderObjects[key] = ro
    }
    
    func insertAlarmROs(ros: [AlarmCellRO]) {
        ros.forEach { insertAlarmRO(ro: $0) }
    }
    
    func clearAlarmROs() {
        alarmRenderObjects.removeAll()
    }
    
    func getSorted(ros: [AlarmCellRO]) -> [AlarmCellRO] {
        ros.sorted(by: alarmSortType.compare(direction: .ascending))
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
}


// MARK: Refetch alarms
private extension MainPageInteractor {
    func refetchAndPresentAlarms() {
        let alarmFetchResult = alarmController.readAlarms()
        switch alarmFetchResult {
        case .success(let fetchedAlarms):
            clearAlarms()
            insertAlarms(alarms: fetchedAlarms)
            
            let alarmROs = transform(alarmList: fetchedAlarms)
            clearAlarmROs()
            insertAlarmROs(ros: alarmROs)
            presenter.request(.setAlarmList(getSorted(ros: alarmROs)))
        case .failure(let error):
            debugPrint("Error, \(error.localizedDescription)")
        }
    }
}
