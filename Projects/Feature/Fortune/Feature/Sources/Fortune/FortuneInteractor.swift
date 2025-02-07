//
//  FortuneInteractor.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import RIBs
import RxSwift

public protocol FortuneRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol FortunePresentable: Presentable {
    var listener: FortunePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public enum FortuneListenerRequest {
    case close
}

public protocol FortuneListener: AnyObject {
    func request(_ request: FortuneListenerRequest)
}

final class FortuneInteractor: PresentableInteractor<FortunePresentable>, FortuneInteractable, FortunePresentableListener {

    weak var router: FortuneRouting?
    weak var listener: FortuneListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: FortunePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    func request(_ request: FortunePresentableListenerRequest) {
        switch request {
        case .close:
            listener?.request(.close)
        }
    }
}
