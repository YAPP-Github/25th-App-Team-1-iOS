//
//  AlarmReleaseSnoozeViewController.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/12/25.
//

import RIBs
import RxSwift
import UIKit

protocol AlarmReleaseSnoozePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class AlarmReleaseSnoozeViewController: UIViewController, AlarmReleaseSnoozePresentable, AlarmReleaseSnoozeViewControllable {

    weak var listener: AlarmReleaseSnoozePresentableListener?
    
    override func loadView() {
        view = mainView
    }
    
    private let mainView = AlarmReleaseSnoozeView()
}
