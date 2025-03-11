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
import FeatureDesignSystem

protocol MainPagePresentableListener: AnyObject {
    func request(_ request: MainPageViewPresenterRequest)
}

enum MainPageViewPresenterRequest {
    case viewDidLoad
    case viewWillAppear
    case showFortuneNoti
    case goToSettings
    case createAlarm
    case editAlarm(alarmId: String)
    case changeAlarmActivityState(alarmId: String)
    case changeAlarmCheckState(alarmId: String)
    case deleteAlarm(alarmId: String)
    case changeAlarmListMode(mode: AlarmListMode)
    case presentSingleAlarmDeletionView(alarmId: String)
    case dismissSingleAlarmDeletionView
    case deleteAlarms
    case checkAllAlarmForDeletionButtonTapped
    case screenWithoutAlarmOptionViewTapped
    case alarmOptionButtonTapped
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listener?.request(.viewWillAppear)
    }
    
    func request(_ request: MainPagePresentableRequest) {
        switch request {
        case .setFortuneScore(let score, let userName):
            var orbitState: OrbitRenderState = .beforeFortune
            let defaultUserName = "너"
            if let score {
                switch score {
                case 0..<50:
                    orbitState = .luckScoreOverZero(userName: userName ?? defaultUserName)
                case 50..<80:
                    orbitState = .luckScoreOver50(userName: userName ?? defaultUserName)
                case 80...:
                    orbitState = .luckScoreOver80(userName: userName ?? defaultUserName)
                default:
                    orbitState = .beforeFortune
                }
            }
            mainView.update(.orbitState(orbitState))
        case .setFortuneDeliverMark(let isMarked):
            mainView.update(.turnOnFortuneNoti(isMarked))
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
        case .presentSnackBar(let config):
            let snackBar = DSSnackBar(config: config)
            snackBar.layer.zPosition = 1000
            view.addSubview(snackBar)
            snackBar.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(20)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
            }
            snackBar.play()
        case .setCheckForDeleteAllAlarms(let isOn):
            mainView.update(.setDeleteAllAlarmCheckBox(isOn: isOn))
        case .presentSingleAlarmDeletionView(let ro):
            mainView.update(.singleAlarmDeletionViewPresentation(
                isPresent: true,
                presenting: ro
            ))
        case .dismissSingleAlarmDeletionView:
            mainView.update(.singleAlarmDeletionViewPresentation(
                isPresent: false,
                presenting: nil
            ))
        case .setSingleAlarmDeltionItem(let ro):
            mainView.update(.updateSingleAlarmDeletionItem(ro))
        case .presentAlarmListOption(let isPresenting):
            if isPresenting {
                mainView.update(.presentAlarmOptionListView)
            } else {
                mainView.update(.dismissAlarmOptionListView)
            }
        case .nextFortuneDeliveryTime(let text):
            mainView.update(.fortuneDeliveryTimeText(text))
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
        case .deleteAllAlarmCheckBoxTapped:
            listener?.request(.checkAllAlarmForDeletionButtonTapped)
        case .alarmCellIsLongPressed(let alarmId):
            listener?.request(.presentSingleAlarmDeletionView(alarmId: alarmId))
        case .singleAlarmDeletionViewBackgroundTapped:
            listener?.request(.dismissSingleAlarmDeletionView)
        case .screenWithoutAlarmConfigureViewTapped:
            listener?.request(.screenWithoutAlarmOptionViewTapped)
        case .configureAlarmListButtonClicked:
            listener?.request(.alarmOptionButtonTapped)
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
