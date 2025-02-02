//
//  InputSummaryInteractor.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/15/25.
//

import RIBs
import RxSwift

protocol InputSummaryRouting: ViewableRouting {
    
}

protocol InputSummaryPresentable: Presentable {
    var listener: InputSummaryPresentableListener? { get set }
    
    func presentMainView(onBoadingModel: OnboardingModel, animated: Bool)
    
    func dismissMainView(animated: Bool, completion: @escaping () -> Void)
}

enum InputSummaryListenerRequest {
    
    case dismiss
    case next
}

protocol InputSummaryListener: AnyObject {
    
    func request(_ request: InputSummaryListenerRequest)
}

final class InputSummaryInteractor: PresentableInteractor<InputSummaryPresentable>, InputSummaryInteractable, InputSummaryPresentableListener {

    weak var router: InputSummaryRouting?
    weak var listener: InputSummaryListener?
    
    
    // State
    private let onBoardingModel: OnboardingModel
    private var mainViewIsAppear = false

    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: InputSummaryPresentable, onBoardingModel: OnboardingModel) {
        self.onBoardingModel = onBoardingModel
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


// MARK: InputSummaryPresentableListener
extension InputSummaryInteractor {
    
    func request(_ request: InputSummaryViewRequest) {
        
        switch request {
        case .viewDidAppear:
            
            if !mainViewIsAppear {
                mainViewIsAppear = true
            
                presenter.presentMainView(
                    onBoadingModel: onBoardingModel,
                    animated: true
                )
            }
            
        case .confirmInputs:
            listener?.request(.next)
        case .backToEditInputs:
            listener?.request(.dismiss)
        }
    }
}
