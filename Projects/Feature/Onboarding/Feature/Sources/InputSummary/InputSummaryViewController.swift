//
//  InputSummaryViewController.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/15/25.
//

import RIBs
import RxSwift
import UIKit

enum InputSummaryViewRequest {
    
    case confirmInputs
    case backToEditInputs
}

protocol InputSummaryPresentableListener: AnyObject {
    
    func request(_ request: InputSummaryViewRequest)
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


// MARK: Public interface
extension InputSummaryViewController {
    
    func update(inputs: [String: String]) {
        mainView.update(inputs: inputs)
    }
}


// MARK: InputSummaryViewListener
extension InputSummaryViewController {
    
    func action(_ action: InputSummaryView.Action) {
        switch action {
        case .agreeInSumamry:
            listener?.request(.confirmInputs)
        case .disagreeInSummary:
            listener?.request(.backToEditInputs)
        }
    }
}


#Preview {
    InputSummaryViewController()
}
