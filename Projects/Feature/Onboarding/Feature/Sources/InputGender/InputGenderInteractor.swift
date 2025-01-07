//
//  InputGenderInteractor.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/7/25.
//

import RIBs
import RxSwift

protocol InputGenderRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

enum InputGenderInteractorAction {
    case updateButtonState(isEnabled: Bool)
}

protocol InputGenderPresentable: Presentable {
    var listener: InputGenderPresentableListener? { get set }

    func action(_ action: InputGenderInteractorAction)
}

protocol InputGenderListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class InputGenderInteractor: PresentableInteractor<InputGenderPresentable>, InputGenderInteractable, InputGenderPresentableListener {

    weak var router: InputGenderRouting?
    weak var listener: InputGenderListener?
    
    
    // State
    private(set) var state: State = .init()
    

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: InputGenderPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        presenter.action(.updateButtonState(isEnabled: false))
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}


// MARK: Data model
extension InputGenderInteractor {
    
    struct State {
        var gender: Gender? = nil
    }
}


// MARK: InputGenderPresentableListener
extension InputGenderInteractor {
    
    func request(_ request: InputGenderPresenterRequest) {
        
        switch request {
        case .updateSelectedGender(let gender):
            
            state.gender = gender
            
            let buttonIsEnabled = (gender != nil)
            
            presenter.action(.updateButtonState(isEnabled: buttonIsEnabled))
            
        case .confirmCurrentGender:
            print("confirm gender")
        case .exitPage:
            print("exit page")
        }
    }
}
