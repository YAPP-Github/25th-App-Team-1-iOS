//
//  ShakeMissionMainViewController.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 1/20/25.
//

import UIKit

import FeatureDesignSystem

import RIBs
import RxSwift

protocol ShakeMissionMainPresentableListener: AnyObject {
    
    func request(_ request: ShakeMissionMainPresenterRequest)
}

enum ShakeMissionMainPresenterRequest {
    
    case startMission
    case presentAlert(DSTwoButtonAlert.Config)
}

final class ShakeMissionMainViewController: UIViewController, ShakeMissionMainPresentable, ShakeMissionMainViewControllable, ShakeMissionMainViewListener {

    weak var listener: ShakeMissionMainPresentableListener?
    
    private(set) var mainView: ShakeMissionMainView?
    
    override func loadView() {
        let mainView = ShakeMissionMainView()
        self.mainView = mainView
        self.view = mainView
        mainView.listener = self
    }
}


// MARK: ShakeMissionMainViewListener
extension ShakeMissionMainViewController {
    
    func action(_ action: ShakeMissionMainView.Action) {
        switch action {
        case .startMissionButtonClicked:
            listener?.request(.startMission)
        case .rejectMissionButtonClicked:
            let alertConfig: DSTwoButtonAlert.Config = .init(
                titleText: "나가면 운세를 받을 수 없어요",
                subTitleText: "미션을 수행하지 않고 나가시겠어요?",
                leftButtonText: "취소",
                rightButtonText: "나가기"
            )
            listener?.request(.presentAlert(alertConfig))
        }
    }
}
