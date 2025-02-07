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
    case changeAlarmState(alarmId: String, changeToActive: Bool)
    case deleteAlarm(alarmId: String)
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
        case let .setAlarmList(alarmList):
            if alarmList.isEmpty {
                view = emptyView
            } else {
                view = mainView
                mainView.update(.presentAlarmCell(list: alarmList))
            }
        }
    }
    
    private let mainView = MainPageView()
    private let emptyView = EmptyAlarmView()
}


// MARK: Public interface
extension MainPageViewController {
    enum UpdateRequest {
        // Alarm엔티티 전달
        case presentAlarmList(alarms: [Alarm])
    }
    
    func update(_ request: UpdateRequest) {
        switch request {
        case .presentAlarmList(let alarms):
            // 엔티티를 RO로 변경
            mainView.update(.presentAlarmCell(list: alarms))
        }
    }
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
        case .alarmStateWillChange(let alarmId, let isActive):
            listener?.request(.changeAlarmState(
                alarmId: alarmId,
                changeToActive: isActive
            ))
        case .alarmWillDelete(let alarmId):
            listener?.request(.deleteAlarm(alarmId: alarmId))
            break
        }
    }
}

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


//#Preview {
//    let vc = MainPageViewController()
//    vc.loadView()
//    
//    let testLists = (0..<10).map { _ in
//        AlarmCellRO(
//            iterationType: .specificDay(month: 1, day: 2),
//            meridiem: .am,
//            hour: 1,
//            minute: 5,
//            isActive: true
//        )
//    }
//    
//    if let mainView = vc.view as? MainPageView {
//        mainView
//            .update(.orbitState(.luckScoreOverZero(userName: "준영")))
//            .update(.fortuneDeliveryTimeText("내일 오전 5:00 도착"))
//            .update(.turnOnFortuneNoti(true))
//            .update(.turnOnFortuneIsDeliveredBubble(true))
//            .update(.presentAlarmCell(list: testLists))
//    }
//        
//    
//    return vc
//}
