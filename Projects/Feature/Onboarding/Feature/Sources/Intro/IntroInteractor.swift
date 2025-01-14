//
//  IntroInteractor.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import RIBs
import RxSwift

protocol IntroRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol IntroPresentable: Presentable {
    var listener: IntroPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

enum IntroListenerRequest {
    case next
}

protocol IntroListener: AnyObject {
    func request(_ request: IntroListenerRequest)
}

final class IntroInteractor: PresentableInteractor<IntroPresentable>, IntroInteractable, IntroPresentableListener {

    weak var router: IntroRouting?
    weak var listener: IntroListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: IntroPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    func request(_ request: IntroPresentableListenerRequest) {
        switch request {
        case .next:
            listener?.request(.next)
        }
    }
}
