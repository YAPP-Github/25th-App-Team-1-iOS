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

enum InputGenderListenerRequest {
    case back
    case next(Gender)
}

protocol InputGenderListener: AnyObject {
    func request(_ request: InputGenderListenerRequest)
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
        case .viewDidLoad:
            
            presenter.action(.updateButtonState(isEnabled: false))
            
        case .updateSelectedGender(let gender):
            
            state.gender = gender
            
            let buttonIsEnabled = (gender != nil)
            presenter.action(.updateButtonState(isEnabled: buttonIsEnabled))
            
        case .confirmCurrentGender:
            guard let gender = state.gender else { return }
            listener?.request(.next(gender))
        case .exitPage:
            listener?.request(.back)
        }
    }
}
