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
    case setFortuneScore(score: Int?, userName: String?)
    case setCheckForDeleteAllAlarms(isOn: Bool)
}

protocol MainPagePresentable: Presentable {
    var listener: MainPagePresentableListener? { get set }
    func request(_ request: MainPagePresentableRequest)
}

public protocol MainPageListener: AnyObject {}

final class MainPageInteractor: PresentableInteractor<MainPagePresentable>, MainPageInteractable, MainPagePresentableListener {
    
    weak var router: MainPageRouting?
    weak var listener: MainPageListener?
    
    // State
    private var alarmCellROs: [AlarmCellRO] = []
    // - 알림이 삭제를 위해 체크된 상태관리
    private var checkedState: [String: Bool] = [:]
    private var alarmListMode: AlarmListMode = .idle
    private var deleteAllAlarmsChecked: Bool = false
    
    // Fortune
    private var fortune: FortuneSaveInfo?
    
    
    init(
        presenter: MainPagePresentable,
        service: MainPageServiceable
    ) {
        self.service = service
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    private let service: MainPageServiceable
}

// MARK: - MainPageViewPresenterRequest
extension MainPageInteractor {
    func request(_ request: MainPageViewPresenterRequest) {
        switch request {
        case .viewDidLoad:
            let alarmList = service.getAllAlarm()
            let renderObjects = transform(alarmList: alarmList)
            self.alarmCellROs = renderObjects
            presenter.request(.setAlarmList(renderObjects))
        case .viewWillAppear:
            // 유저정보와 운세정보를 확인하여 오르빗 상태 업데이트
            let userInfo = Preference.userInfo
            
            if let todayFortune = UserDefaults.standard.dailyFortune() {
                if fortune == todayFortune {
                    // 운세가 이미 UI로 표현된 경우
                    return
                }
                // 오늘의 운세가 있는 경우
                let isDailyForuneIsChecked = UserDefaults.standard.dailyFortuneIsChecked()
                if isDailyForuneIsChecked {
                    // 오늘 운세가 확인된 경우, API를 통해 점수를 확인
                    let fortuneId = todayFortune.id
                    let request = APIRequest.Fortune.getFortune(fortuneId: fortuneId)
                    APIClient.request(Fortune.self, request: request) { [weak self] fortune in
                        guard let self else { return }
                        let score = fortune.avgFortuneScore
                        presenter.request(.setFortuneScore(score: score, userName: userInfo?.name))
                        self.fortune = todayFortune
                    } failure: { error in
                        print(error)
                    }
                } else {
                    // 오늘 운세가 확인되지 않은 경우, 편지함에 빨간점 추가
                    presenter.request(.setFortuneDeliverMark(isMarked: true))
                }
            } else {
                // 운세가 없는 경우
                presenter.request(.setFortuneScore(score: nil, userName: nil))
                presenter.request(.setFortuneDeliverMark(isMarked: false))
            }

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
            guard let alarm = service.getAllAlarm().first(where: { $0.id == alarmId }) else { return }
            router?.request(.routeToCreateEditAlarm(mode: .edit(alarm)))
        case let .changeAlarmActivityState(alarmId):
            guard var alarm = service.getAllAlarm().first(where: { $0.id == alarmId }) else { return }
            let nextState = !alarm.isActive
            
            let changeAlarmActivity = { [weak self] in
                guard let self else { return }
                // 로직 업데이트
                alarm.isActive = nextState
                service.updateAlarm(alarm)
                
                // UI업데이트
                let updatedROs = alarmCellROs.map { ro in
                    if ro.id == alarmId {
                        var newRO = ro
                        newRO.isToggleOn = nextState
                        return newRO
                    }
                    return ro
                }
                self.alarmCellROs = updatedROs
                presenter.request(.setAlarmList(updatedROs))
            }
            
            let currentActiveAlarmCount = alarmCellROs.filter({ $0.isToggleOn }).count
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
            guard let alarm = service.getAllAlarm().first(where: { $0.id == alarmId }) else { return }
            // 비즈니스 로직 업데이트
            service.deleteAlarm(alarm)
            
            // UI업데이트
            if let index = alarmCellROs.firstIndex(where: { $0.id == alarmId }) {
                alarmCellROs.remove(at: index)
                presenter.request(.setAlarmList(alarmCellROs))
            }
        case .changeAlarmListMode(let mode):
            self.alarmListMode = mode
            self.checkedState = [:]
            let newROs = self.alarmCellROs.map { ro in
                var newRO = ro
                newRO.isChecked = false
                newRO.mode = mode
                return newRO
            }
            self.alarmCellROs = newROs
            self.deleteAllAlarmsChecked = false
            presenter.request(.setCheckForDeleteAllAlarms(isOn: false))
            presenter.request(.setAlarmList(alarmCellROs))
            presenter.request(.setAlarmListMode(mode))
            presenter.request(.setCountForAlarmsCheckedForDeletion(countOfAlarms: 0))
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
            let newROs = alarmCellROs.map { ro in
                if ro.id == alarmId {
                    var newRO = ro
                    newRO.isChecked = nextState
                    return newRO
                }
                return ro
            }
            self.alarmCellROs = newROs
            presenter.request(.setAlarmList(newROs))
            presenter.request(.setCountForAlarmsCheckedForDeletion(
                countOfAlarms: self.checkedState.keys.count
            ))
            
            let alarmCellCount = alarmCellROs.count
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
                    let alarms = service.getAllAlarm()
                    let willDeleteAlarms = alarms.filter { alarm in
                        self.checkedState[alarm.id] == true
                    }
                    willDeleteAlarms.forEach { alarm in
                        self.service.deleteAlarm(alarm)
                    }
                    
                    // UI 업데이트
                    let newROs = alarmCellROs.filter { ro in
                        self.checkedState[ro.id] != true
                    }.map { ro in
                        var newRO = ro
                        newRO.mode = .idle
                        newRO.isChecked = false
                        return newRO
                    }
                    self.alarmCellROs = newROs
                    self.checkedState = [:]
                    self.alarmListMode = .idle
                    presenter.request(.setAlarmListMode(.idle))
                    presenter.request(.setAlarmList(newROs))
                    presenter.request(.setCountForAlarmsCheckedForDeletion(countOfAlarms: 0))
                    
                    let config: DSSnackBar.SnackBarConfig = .init(
                        status: .success,
                        titleText: "삭제되었어요.",
                        buttonText: "취소",
                        buttonCompletion: { [weak self] in
                            guard let self else { return }
                            willDeleteAlarms.forEach { alarm in
                                // 복구
                                self.service.addAlarm(alarm)
                            }
                            // UI업데이트
                            let newAlarmList = service.getAllAlarm()
                            let alarmCellROs = transform(alarmList: newAlarmList)
                            self.alarmCellROs = alarmCellROs
                            presenter.request(.setAlarmList(alarmCellROs))
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
                let newROs = alarmCellROs.map { ro in
                    var newRO = ro
                    newRO.isChecked = false
                    return newRO
                }
                self.checkedState = [:]
                self.alarmCellROs = newROs
                presenter.request(.setAlarmList(newROs))
                presenter.request(.setCountForAlarmsCheckedForDeletion(countOfAlarms: 0))
            } else {
                // 전체선택
                let newROs = alarmCellROs.map { ro in
                    var newRO = ro
                    newRO.isChecked = true
                    self.checkedState[ro.id] = true
                    return newRO
                }
                self.alarmCellROs = newROs
                presenter.request(.setAlarmList(newROs))
                presenter.request(.setCountForAlarmsCheckedForDeletion(
                    countOfAlarms: self.checkedState.keys.count
                ))
            }
            self.deleteAllAlarmsChecked = !prevState
            presenter.request(.setCheckForDeleteAllAlarms(isOn: deleteAllAlarmsChecked))
        }
    }
    
    private func transform(alarmList: [Alarm]) -> [AlarmCellRO] {
        alarmList.map { alarmEntity in
            let isChecked = self.checkedState[alarmEntity.id] == true
            return AlarmCellRO(
                id: alarmEntity.id,
                alarmDays: alarmEntity.repeatDays,
                meridiem: alarmEntity.meridiem,
                hour: alarmEntity.hour,
                minute: alarmEntity.minute,
                isToggleOn: alarmEntity.isActive,
                isChecked: isChecked,
                mode: self.alarmListMode
            )
        }
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
            }) { [weak self] error in
                guard let self else { return }
                // 유저정보 획득 실패
                debugPrint(error.localizedDescription)
            }
    }
    
    private func checkIsFirstAlarm(with alarm: Alarm) -> Bool {
        let alarmList = service.getAllAlarm()
        let activeAlarmList = alarmList.filter { $0.isActive }
        let meridiem = alarm.meridiem
        if let firstAlarm = activeAlarmList.sorted(by: { $0.hour.to24Hour(with: meridiem) < $1.hour.to24Hour(with: meridiem) }).sorted(by: { $0.minute.value < $1.minute.value }).first {
            return firstAlarm.id == alarm.id
        }
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
            service.addAlarm(alarm)
            let config: DSSnackBar.SnackBarConfig = .init(
                status: .success,
                titleText: "기상 알람이 추가되었어요."
            )
            presenter.request(.presentSnackBar(config: config))
            
        case let .updated(alarm):
            service.updateAlarm(alarm)
        case let .deleted(alarm):
            service.deleteAlarm(alarm)
        }
        
        // UI업데이트
        let newAlarmList = service.getAllAlarm()
        let alarmCellROs = transform(alarmList: newAlarmList)
        self.alarmCellROs = alarmCellROs
        presenter.request(.setAlarmList(alarmCellROs))
    }
}


// MARK: ShakeMissionMainListener
extension MainPageInteractor {
    func request(_ request: FeatureAlarmMission.ShakeMissionMainListenerRequest) {
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
        guard let alarm = service.getAllAlarm().first(where: { $0.id == alarmId }) else { return .just((self, ())) }
        let isFirstAlarm = self.checkIsFirstAlarm(with: alarm)
        router?.request(.routeToAlarmRelease(alarm, isFirstAlarm))
        return .just((self, ()))
    }

}


// MARK: SettingMainListener
extension MainPageInteractor {
    func dismiss() {
        router?.request(.dismissSettingPage)
    }
}
