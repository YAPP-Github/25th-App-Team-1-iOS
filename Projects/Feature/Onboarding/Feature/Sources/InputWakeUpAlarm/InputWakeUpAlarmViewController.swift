//
//  InputWakeUpAlarmViewController.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/4/25.
//

import RIBs
import RxSwift
import UIKit
import FeatureCommonDependencies

enum InputWakeUpAlarmPresenterRequest {
    case viewDidLoad
    case exitPage
    case confirmUserInputAndExit
    case updateCurrentAlarmData(Meridiem, Hour, Minute)
}

protocol InputWakeUpAlarmPresentableListener: AnyObject {
    
    func request(_ request: InputWakeUpAlarmPresenterRequest)
}

final class InputWakeUpAlarmViewController: UIViewController, InputWakeUpAlarmPresentable, InputWakeUpAlarmViewControllable, InputWakeUpAlarmViewListener {
    weak var listener: InputWakeUpAlarmPresentableListener?
    
    override func loadView() {
        self.view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        listener?.request(.viewDidLoad)
    }
    
    func request(_ request: InputWakeUpAlarmPresentableRequest) {
        switch request {
        case let .setAlarm(alarm):
            mainView.setAlarm(alarm)
        }
    }
    
    private let mainView = InputWakeUpAlarmView()
}


// MARK: InputWakeUpAlarmViewListener
extension InputWakeUpAlarmViewController {
    
    func action(_ action: InputWakeUpAlarmView.Action) {
        
        switch action {
        case .backButtonClicked:
            listener?.request(.exitPage)
        case let .alarmPicker(meridiem, hour, minute):
            listener?.request(.updateCurrentAlarmData(meridiem, hour, minute))
        case .ctaButtonClicked:
            listener?.request(.confirmUserInputAndExit)
        }
    }
}


// MARK: Preview
#Preview {
    
    InputWakeUpAlarmViewController()
}
