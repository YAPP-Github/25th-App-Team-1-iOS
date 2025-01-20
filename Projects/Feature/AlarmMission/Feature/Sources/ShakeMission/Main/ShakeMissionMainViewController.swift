//
//  ShakeMissionMainViewController.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 1/20/25.
//

import RIBs
import RxSwift
import UIKit

protocol ShakeMissionMainPresentableListener: AnyObject {
    
    func request(_ request: ShakeMissionMainPresenterRequest)
}

enum ShakeMissionMainPresenterRequest {
    
    case startMission
    case exitPage
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
            listener?.request(.exitPage)
        }
    }
}
