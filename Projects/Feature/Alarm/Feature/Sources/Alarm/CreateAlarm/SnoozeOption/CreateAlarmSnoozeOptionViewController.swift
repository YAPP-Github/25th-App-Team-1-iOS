//
//  CreateAlarmSnoozeOptionViewController.swift
//  FeatureAlarm
//
//  Created by ever on 1/20/25.
//

import RIBs
import RxSwift
import UIKit

protocol CreateAlarmSnoozeOptionPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class CreateAlarmSnoozeOptionViewController: UIViewController, CreateAlarmSnoozeOptionPresentable, CreateAlarmSnoozeOptionViewControllable {

    weak var listener: CreateAlarmSnoozeOptionPresentableListener?
    
    override func loadView() {
        view = mainView
    }
    
    private let mainView = CreateAlarmSnoozeOptionView()
    
    
}
