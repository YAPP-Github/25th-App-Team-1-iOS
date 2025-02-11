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
    private var timer: Timer?

    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(timerFired),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc
    private func timerFired() {
        mainView.generateCurrentTime()
    }
    
    private let mainView = AlarmReleaseIntroView()
    
    deinit {
        timer?.invalidate()
    }
}
