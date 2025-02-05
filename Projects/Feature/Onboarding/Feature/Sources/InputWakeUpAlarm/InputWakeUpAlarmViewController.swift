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
    
    case exitPage
    case confirmUserInputAndExit
    case updateCurrentAlarmData(Meridiem, Hour, Minute)
}

protocol InputWakeUpAlarmPresentableListener: AnyObject {
    
    func request(_ request: InputWakeUpAlarmPresenterRequest)
}

final class InputWakeUpAlarmViewController: UIViewController, InputWakeUpAlarmPresentable, InputWakeUpAlarmViewControllable, InputWakeUpAlarmViewListener {

    
    weak var listener: InputWakeUpAlarmPresentableListener?
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { nil
    }
    
    private let mainView = InputWakeUpAlarmView()
    
    override func loadView() {
        
        self.view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
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
