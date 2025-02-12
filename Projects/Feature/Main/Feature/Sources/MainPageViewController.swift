//
//  MainPageViewController.swift
//  FeatureMain
//
//  Created by choijunios on 1/27/25.
//

import RIBs
import RxSwift
import UIKit
import FeatureCommonDependencies

protocol MainPagePresentableListener: AnyObject {
    func request(_ request: MainPageViewPresenterRequest)
}

enum MainPageViewPresenterRequest {
    case viewDidLoad
    case showFortuneNoti
    case goToSettings
    case createAlarm
    case editAlarm(alarmId: String)
    case changeAlarmActivityState(alarmId: String)
    case changeAlarmCheckState(alarmId: String)
    case deleteAlarm(alarmId: String)
    case changeAlarmListMode(mode: AlarmListMode)
    case deleteAlarms
    case selectAllAlarmsForDeletion
    case releaseAllAlarmsForDeletion
}

final class MainPageViewController: UIViewController, MainPagePresentable, MainPageViewControllable, MainPageViewListener {
    weak var listener: MainPagePresentableListener?
    
    override func loadView() {
        view = emptyView
        emptyView.listener = self
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listener?.request(.viewDidLoad)
        mainView.update(.orbitState(.beforeFortune))
    }
    
    func request(_ request: MainPagePresentableRequest) {
        switch request {
        case let .setAlarmList(alarmCellROs):
            if alarmCellROs.isEmpty {
                view = emptyView
            } else {
                view = mainView
                mainView.update(.presentAlarmCell(list: alarmCellROs))
            }
        case .setAlarmListMode(let mode):
            switch mode {
            case .idle:
                mainView.update(.dismissAlarmGroupDeletionView)
            case .deletion:
                mainView.update(.presentAlarmGroupDeletionView)
            }
            break
        case .setCountForAlarmsCheckedForDeletion(let count):
            let isActive: Bool = (count != 0)
            var text: String = "삭제"
            if count != 0 {
                text = "\(count)개 삭제"
            }
            mainView.update(.alarmGroupDeletionButton(isActive: isActive, text: text))
        }
    }
    
    private let mainView = MainPageView()
    private let emptyView = EmptyAlarmView()
}


// MARK: MainPageViewListener
extension MainPageViewController {
    func action(_ action: MainPageView.Action) {
        switch action {
        case .fortuneNotiButtonClicked:
            listener?.request(.showFortuneNoti)
        case .applicationSettingButtonClicked:
            listener?.request(.goToSettings)
        case .addAlarmButtonClicked:
            listener?.request(.createAlarm)
        case .alarmSelected(let alarmId):
            listener?.request(.editAlarm(alarmId: alarmId))
        case .alarmActivityStateWillChange(let alarmId):
            listener?.request(.changeAlarmActivityState(alarmId: alarmId))
        case .alarmWillDelete(let alarmId):
            listener?.request(.deleteAlarm(alarmId: alarmId))
        case .alarmsWillDelete:
            listener?.request(.deleteAlarms)
        case .alarmIsChecked(alarmId: let alarmId):
            listener?.request(.changeAlarmCheckState(alarmId: alarmId))
        case .changeModeToDeletionButtonClicked:
            listener?.request(.changeAlarmListMode(mode: .deletion))
        case .changeModeToIdleButtonClicked:
            listener?.request(.changeAlarmListMode(mode: .idle))
        case .allAlarmsForDeletionSelected:
            listener?.request(.selectAllAlarmsForDeletion)
        case .allAlarmsForDeletionUnSelected:
            listener?.request(.releaseAllAlarmsForDeletion)
        }
    }
}


// MARK: EmptyAlarmViewListener
extension MainPageViewController: EmptyAlarmViewListener {
    func action(_ action: EmptyAlarmView.Action) {
        switch action {
        case .fortuneNotiButtonTapped:
            listener?.request(.showFortuneNoti)
        case .applicationSettingButtonTapped:
            listener?.request(.goToSettings)
        case .addAlarmButtonTapped:
            listener?.request(.createAlarm)
        }
    }
}
