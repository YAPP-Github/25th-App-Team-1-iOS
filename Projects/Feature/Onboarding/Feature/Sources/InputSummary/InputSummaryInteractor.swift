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
    private let model: OnboardingModel
    private var mainViewIsAppear = false

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: InputSummaryPresentable, model: OnboardingModel) {
        self.model = model
        super.init(presenter: presenter)
        presenter.listener = self
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
                    onBoadingModel: model,
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
