//
//  TapMissionMainViewController.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 3/4/25.
//

import RIBs
import RxSwift
import UIKit

protocol TapMissionMainPresentableListener: AnyObject {
    func request(_ request: TapMissionMainPresenterRequest)
}

enum TapMissionMainPresenterRequest {
    case startMission
    case exitPage
}

final class TapMissionMainViewController: UIViewController, TapMissionMainPresentable, TapMissionMainViewControllable, TapMissionMainViewListener {
    
    

    weak var listener: TapMissionMainPresentableListener?
    
    private(set) var mainView: TapMissionMainView?
    
    override func loadView() {
        let mainView = TapMissionMainView()
        self.mainView = mainView
        self.view = mainView
        mainView.listener = self
    }
}


// MARK: TapMissionMainViewListener
extension TapMissionMainViewController {
    func action(_ action: TapMissionMainView.Action) {
        switch action {
        case .startMissionButtonClicked:
            listener?.request(.startMission)
        case .rejectMissionButtonClicked:
            listener?.request(.exitPage)
        }
    }
}
