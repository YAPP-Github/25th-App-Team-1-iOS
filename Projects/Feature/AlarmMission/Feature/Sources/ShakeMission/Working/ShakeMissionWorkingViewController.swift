//
//  ShakeMissionWorkingViewController.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 1/20/25.
//

import RIBs
import RxSwift
import UIKit

protocol ShakeMissionWorkingPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class ShakeMissionWorkingViewController: UIViewController, ShakeMissionWorkingPresentable, ShakeMissionWorkingViewControllable, ShakeMissionWorkingViewListener {

    private(set) var mainView: ShakeMissionWorkingView!
    
    weak var listener: ShakeMissionWorkingPresentableListener?
    
    override func loadView() {
        let mainView = ShakeMissionWorkingView()
        self.mainView = mainView
        self.view = mainView
        mainView.listener = self
    }
}


// MARK: ShakeMissionWorkingViewListener
extension ShakeMissionWorkingViewController {
    
    func action(_ action: ShakeMissionWorkingView.Action) {
        
    }
}

#Preview {
    ShakeMissionWorkingViewController()
}
