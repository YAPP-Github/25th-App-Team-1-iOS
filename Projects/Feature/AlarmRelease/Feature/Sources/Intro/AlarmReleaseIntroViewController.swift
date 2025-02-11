//
//  AlarmReleaseIntroViewController.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/10/25.
//

import RIBs
import RxSwift
import UIKit

protocol AlarmReleaseIntroPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class AlarmReleaseIntroViewController: UIViewController, AlarmReleaseIntroPresentable, AlarmReleaseIntroViewControllable {

    weak var listener: AlarmReleaseIntroPresentableListener?
    
    override func loadView() {
        view = mainView
    }
    
    private let mainView = AlarmReleaseIntroView()
}
