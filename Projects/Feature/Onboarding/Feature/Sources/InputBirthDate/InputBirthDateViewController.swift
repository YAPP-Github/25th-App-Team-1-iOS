//
//  InputBirthDateViewController.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/8/25.
//

import RIBs
import RxSwift
import UIKit

protocol InputBirthDatePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class InputBirthDateViewController: UIViewController, InputBirthDatePresentable, InputBirthDateViewControllable, InputBirthDateViewListener {

    weak var listener: InputBirthDatePresentableListener?
    
    private(set) var mainView: InputBirthDateView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { nil
    }
    
    override func loadView() {
        
        self.mainView = InputBirthDateView()
        self.view = mainView
        mainView.listener = self
    }
}


// MARK: InputBirthDateViewListener
extension InputBirthDateViewController {
    
    func action(_ action: InputBirthDateView.Action) {
        
        //
    }
}
