//
//  CreateAlarmSoundOptionViewController.swift
//  FeatureAlarm
//
//  Created by ever on 1/26/25.
//

import RIBs
import RxSwift
import UIKit

protocol CreateAlarmSoundOptionPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class CreateAlarmSoundOptionViewController: UIViewController, CreateAlarmSoundOptionPresentable, CreateAlarmSoundOptionViewControllable {

    weak var listener: CreateAlarmSoundOptionPresentableListener?
    
    override func loadView() {
        view = mainView
    }
    
    private let mainView = CreateAlarmSoundOptionView()
}
