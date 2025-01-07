//
//  InputGenderViewController.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/7/25.
//

import RIBs
import RxSwift
import UIKit

protocol InputGenderPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class InputGenderViewController: UIViewController, InputGenderPresentable, InputGenderViewControllable, InputGenderViewListener {

    weak var listener: InputGenderPresentableListener?
    
    override func loadView() {
        
        let mainView = InputGenderView()
        self.view = mainView
        mainView.listener = self
    }
}


// MARK: InputGenderViewListener
extension InputGenderViewController {
    
    func action(_ action: InputGenderView.Request) {
        
        //
    }
}


#Preview {
    InputGenderViewController()
}
