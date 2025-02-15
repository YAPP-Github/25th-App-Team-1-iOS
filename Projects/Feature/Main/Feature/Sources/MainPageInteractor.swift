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
    case routeToAlarmMission
    case detachAlarmMission((() -> Void)?)
    case routeToFortune(Fortune, UserInfo)
    case detachFortune
    case routeToAlarmRelease(Alarm)
    case detachAlarmRelease((() -> Void)?)
    case presentAlertType1(DSButtonAlert.Config)
    case presentAlertType2(DSTwoButtonAlert.Config, DSTwoButtonAlertViewControllerListener)
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
    
    
    // AlertListener
    private var alertListener: [String: AlertListener] = [:]
    
    
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
            
            if UserDefaults.standard.dailyFortuneId() != nil {
                presenter.request(.setFortuneDeliverMark(isMarked: true))
            }
        case .showFortuneNoti:
            guard let fortuneId = UserDefaults.standard.dailyFortuneId() else {
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
            
            let request = APIRequest.Fortune.getFortune(fortuneId: fortuneId)
            APIClient.request(Fortune.self, request: request) { [weak self] fortune in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.goToFortune(fortune: fortune)
                }
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
            // 로직 업데이트
            let nextState = !alarm.isActive
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
                newRO.mode = mode
                return newRO
            }
            self.alarmCellROs = newROs
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
        case .deleteAlarms:
            
            let alertConfig: DSTwoButtonAlert.Config = .init(
                titleText: "알람 삭제",
                subTitleText: "삭제하시겠어요?",
                leftButtonText: "취소",
                rightButtonText: "삭제"
            )
            let alertListenerKey = "deleteAlarms"
            let alertListener = AlertListener()
            alertListener.leftTapped = { [weak self] in
                guard let self else { return }
                router?.request(.dismissAlert())
                self.alertListener.removeValue(forKey: alertListenerKey)
            }
            alertListener.rightTapped = { [weak self] in
                guard let self else { return }
                router?.request(.dismissAlert())
                self.alertListener.removeValue(forKey: alertListenerKey)
                
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
            
            self.alertListener[alertListenerKey] = alertListener
            router?.request(.presentAlertType2(alertConfig, alertListener))
            
        case .selectAllAlarmsForDeletion:
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
        case .releaseAllAlarmsForDeletion:
            let newROs = alarmCellROs.map { ro in
                var newRO = ro
                newRO.isChecked = false
                return newRO
            }
            self.checkedState = [:]
            self.alarmCellROs = newROs
            presenter.request(.setAlarmList(newROs))
            presenter.request(.setCountForAlarmsCheckedForDeletion(countOfAlarms: 0))
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
    
    private func goToFortune(fortune: Fortune) {
        guard let userId = Preference.userId else { return }
        APIClient.request(
            UserInfoResponseDTO.self,
            request: APIRequest.Users.getUser(userId: userId),
            success: { [weak router] userInfo in
                guard let router else { return }
                let userInfoEntity = userInfo.toUserInfo()
                DispatchQueue.main.async {
                    router.request(.routeToFortune(fortune, userInfoEntity))
                }
            }) { [weak self] error in
                guard let self else { return }
                // 유저정보 획득 실패
                debugPrint(error.localizedDescription)
            }
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

extension MainPageInteractor {
    func request(_ request: FeatureAlarmMission.ShakeMissionMainListenerRequest) {
        switch request {
        case let .close(fortune):
            router?.request(.detachAlarmMission { [weak self] in
                guard let self, let fortune else { return }
                goToFortune(fortune: fortune)
            })
        }
    }
}

// MARK: - FortuneListenerRequest
extension MainPageInteractor {
    func request(_ request: FeatureFortune.FortuneListenerRequest) {
        switch request {
        case .close:
            router?.request(.detachFortune)
        }
    }
}

extension MainPageInteractor {
    func request(_ request: FeatureAlarmRelease.AlarmReleaseIntroListenerRequest) {
        switch request {
        case .releaseAlarm:
            router?.request(.detachAlarmRelease({ [weak router] in
                router?.request(.routeToAlarmMission)
            }))
        }
    }
}

extension MainPageInteractor: MainPageActionableItem {
    func showAlarm(alarmId: String) -> Observable<(MainPageActionableItem, ())> {
        guard let alarm = service.getAllAlarm().first(where: { $0.id == alarmId }) else { return .just((self, ())) }
        router?.request(.routeToAlarmRelease(alarm))
        return .just((self, ()))
    }

}


// MARK: SettingMainListener
extension MainPageInteractor {
    func dismiss() {
        router?.request(.dismissSettingPage)
    }
}
