//
//  InputBirthDateInteractor.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/8/25.
//

import RIBs
import RxSwift

protocol InputBirthDateRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol InputBirthDatePresentable: Presentable {
    var listener: InputBirthDatePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

enum InputBirthDateListenerRequest {
    case confirmBirthDate(BirthDateData)
}

protocol InputBirthDateListener: AnyObject {
    func request(_ request: InputBirthDateListenerRequest)
}

final class InputBirthDateInteractor: PresentableInteractor<InputBirthDatePresentable>, InputBirthDateInteractable, InputBirthDatePresentableListener {

    weak var router: InputBirthDateRouting?
    weak var listener: InputBirthDateListener?
    
    
    // State
    private(set) var birthDate: BirthDateData?
    

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: InputBirthDatePresentable) {
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


// MARK: InputBirthDatePresentableListener
extension InputBirthDateInteractor {
    
    func request(_ request: InputBirthDatePresenterRequest) {
        switch request {
        case .exitPage:
            print("exit")
        case .confirmUserInputAndExit:
            guard let birthDate else { return }
            listener?.request(.confirmBirthDate(birthDate))
        case .updateCurrentBirthDate(let birthDateData):
            self.birthDate = birthDateData
            print(birthDateData)
        }
    }
}
