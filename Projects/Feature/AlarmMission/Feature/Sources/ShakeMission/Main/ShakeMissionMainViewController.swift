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
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
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
        
    }
}
