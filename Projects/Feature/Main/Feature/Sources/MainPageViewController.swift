//
//  MainPageViewController.swift
//  FeatureMain
//
//  Created by choijunios on 1/27/25.
//

import RIBs
import RxSwift
import UIKit

protocol MainPagePresentableListener: AnyObject {
    func request(_ request: MainPageViewPresenterRequest)
}

enum MainPageViewPresenterRequest {
    case changeAlarmState(alarmId: String, changeToActive: Bool)
}

final class MainPageViewController: UIViewController, MainPagePresentable, MainPageViewControllable, MainPageViewListener {

    private(set) var mainView: MainPageView!
    weak var listener: MainPagePresentableListener?
    
    override func loadView() {
        let mainView = MainPageView()
        self.mainView = mainView
        self.view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


// MARK: Public interface
extension MainPageViewController {
    enum UpdateRequest {
        // Alarm엔티티 전달
        case presentAlarmList(alarms: [Any])
    }
    
    func update(_ request: UpdateRequest) {
        switch request {
        case .presentAlarmList(let alarms):
            // 엔티티를 RO로 변경
            break
        }
    }
}


// MARK: MainPageViewListener
extension MainPageViewController {
    
    func action(_ action: MainPageView.Action) {
        switch action {
        case .fortuneNotiButtonClicked:
            break
        case .applicationSettingButtonClicked:
            break
        case .alarmStateWillChange(let alarmId, let isActive):
            listener?.request(.changeAlarmState(
                alarmId: alarmId,
                changeToActive: isActive
            ))
        }
    }
}


#Preview {
    let vc = MainPageViewController()
    vc.loadView()
    
    let testLists = (0..<10).map { _ in
        AlarmCellRO(
            iterationType: .specificDay(month: 1, day: 2),
            meridiem: .am,
            hour: 1,
            minute: 5,
            isActive: true
        )
    }
    
    vc.mainView
        .update(.orbitState(.luckScoreOverZero(userName: "준영")))
        .update(.fortuneDeliveryTimeText("내일 오전 5:00 도착"))
        .update(.turnOnFortuneNoti(true))
        .update(.turnOnFortuneIsDeliveredBubble(true))
        .update(.presentAlarmCell(list: testLists))
    
    return vc
}
