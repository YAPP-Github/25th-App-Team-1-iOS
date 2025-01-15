//
//  InputSummaryViewController.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/15/25.
//

import RIBs
import RxSwift
import UIKit

protocol InputSummaryPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class InputSummaryViewController: UIViewController, InputSummaryPresentable, InputSummaryViewControllable, InputSummaryViewListener {
    
    var mainView: InputSummaryView!
    
    weak var listener: InputSummaryPresentableListener?
    
    override func loadView() {
        self.mainView = InputSummaryView()
        self.view = mainView
        mainView.listener = self
    }
}


// MARK: InputSummaryViewListener
extension InputSummaryViewController {
    
    func action(_ action: InputSummaryView.Action) {
        
    }
}
