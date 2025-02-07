//
//  InputBirthDateViewController.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/8/25.
//

import RIBs
import RxSwift
import UIKit

enum InputBirthDatePresenterRequest {
    case viewDidLoad
    case exitPage
    case confirmUserInputAndExit
    case updateCurrentBirthDate(BirthDateData)
}

protocol InputBirthDatePresentableListener: AnyObject {
    
    func request(_ request: InputBirthDatePresenterRequest)
}

final class InputBirthDateViewController: UIViewController, InputBirthDatePresentable, InputBirthDateViewControllable, InputBirthDateViewListener {

    weak var listener: InputBirthDatePresentableListener?
    
    override func loadView() {
        
        self.mainView = InputBirthDateView()
        self.view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        listener?.request(.viewDidLoad)
    }
    
    func request(_ request: InputBirthDatePresentableRequest) {
        switch request {
        case let .setBirthDate(birthDateData):
            mainView.setBirthDate(birthDateData)
        }
    }
    
    private(set) var mainView: InputBirthDateView!
}


// MARK: InputBirthDateViewListener
extension InputBirthDateViewController {
    
    func action(_ action: InputBirthDateView.Action) {
        
        switch action {
        case .backButtonClicked:
            listener?.request(.exitPage)
        case .birthDatePicker(let birthDateData):
            listener?.request(.updateCurrentBirthDate(birthDateData))
        case .ctaButtonClicked:
            listener?.request(.confirmUserInputAndExit)
        }
    }
}


#Preview {
    InputBirthDateViewController()
}
