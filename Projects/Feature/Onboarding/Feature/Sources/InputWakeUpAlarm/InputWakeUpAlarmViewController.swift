//
//  InputWakeUpAlarmViewController.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/4/25.
//

import RIBs
import RxSwift
import UIKit

protocol InputWakeUpAlarmPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class InputWakeUpAlarmViewController: UIViewController, InputWakeUpAlarmPresentable, InputWakeUpAlarmViewControllable {

    weak var listener: InputWakeUpAlarmPresentableListener?
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { nil
    }
    
    private let mainView = InputWakeUpAlarmView()
    
    override func loadView() {
        
        self.view = mainView
        
    }
}


// MARK: Preview
#Preview {
    
    InputWakeUpAlarmViewController()
}
