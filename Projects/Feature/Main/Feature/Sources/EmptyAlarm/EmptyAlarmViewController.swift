//
//  EmptyAlarmViewController.swift
//  FeatureMain
//
//  Created by ever on 2/7/25.
//

import RIBs
import RxSwift
import UIKit

protocol EmptyAlarmPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class EmptyAlarmViewController: UIViewController, EmptyAlarmPresentable, EmptyAlarmViewControllable {

    weak var listener: EmptyAlarmPresentableListener?
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    private let mainView = EmptyAlarmView()
}

extension EmptyAlarmViewController: EmptyAlarmViewListener {
    func action(_ action: EmptyAlarmView.Action) {
        
    }
}
