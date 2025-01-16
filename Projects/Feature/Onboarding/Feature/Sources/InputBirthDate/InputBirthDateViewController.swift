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
    
    case exitPage
    case confirmUserInputAndExit
    case updateCurrentBirthDate(BirthDateData)
}

protocol InputBirthDatePresentableListener: AnyObject {
    
    func request(_ request: InputBirthDatePresenterRequest)
}

final class InputBirthDateViewController: UIViewController, InputBirthDatePresentable, InputBirthDateViewControllable, InputBirthDateViewListener {

    weak var listener: InputBirthDatePresentableListener?
    
    private(set) var mainView: InputBirthDateView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { nil }
    
    override func loadView() {
        
        self.mainView = InputBirthDateView()
        self.view = mainView
        mainView.listener = self
    }
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
