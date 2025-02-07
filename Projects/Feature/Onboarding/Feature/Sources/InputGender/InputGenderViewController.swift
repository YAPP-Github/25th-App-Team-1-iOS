//
//  InputGenderViewController.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/7/25.
//

import RIBs
import RxSwift
import UIKit

enum InputGenderPresenterRequest {
    case viewDidLoad
    case updateSelectedGender(Gender?)
    case confirmCurrentGender
    case exitPage
}


protocol InputGenderPresentableListener: AnyObject {
    
    func request(_ request: InputGenderPresenterRequest)
}

final class InputGenderViewController: UIViewController, InputGenderPresentable, InputGenderViewControllable, InputGenderViewListener {

    weak var listener: InputGenderPresentableListener?
    
    private(set) var mainView: InputGenderView!
    
    override func loadView() {
        
        let mainView = InputGenderView()
        self.mainView = mainView
        self.view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listener?.request(.viewDidLoad)
    }
}


// MARK: InputGenderViewListener
extension InputGenderViewController {
    
    func action(_ action: InputGenderView.Action) {
        
        switch action {
            
        case .selectedGender(let gender):
            listener?.request(.updateSelectedGender(gender))
            
        case .backButtonClicked:
            listener?.request(.exitPage)
            
        case .confirmButtonClicked:
            listener?.request(.confirmCurrentGender)
        }
    }
}


// MARK: InputGenderPresentable, 인터렉터가 전달하는 액션
extension InputGenderViewController {
    
    func action(_ action: InputGenderInteractorAction) {
        
        switch action {
        case let .setGender(gender):
            mainView.setGender(gender)
        case .updateButtonState(let isEnabled):
            
            mainView.updateCtaButton(isEnabled: isEnabled)
        }
    }
}


#Preview {
    InputGenderViewController()
}
