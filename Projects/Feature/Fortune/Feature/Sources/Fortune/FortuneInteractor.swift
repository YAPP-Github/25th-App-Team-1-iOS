//
//  FortuneInteractor.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import RIBs
import RxSwift
import FeatureCommonDependencies

public protocol FortuneRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

enum FortunePresentableRequest {
    case setFortune(Fortune)
}

protocol FortunePresentable: Presentable {
    var listener: FortunePresentableListener? { get set }
    func request(_ request: FortunePresentableRequest)
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

    init(
        presenter: FortunePresentable,
        fortune: Fortune
    ) {
        self.fortune = fortune
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    func request(_ request: FortunePresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            presenter.request(.setFortune(fortune))
        case .close:
            listener?.request(.close)
        }
    }
    
    private let fortune: Fortune
}
