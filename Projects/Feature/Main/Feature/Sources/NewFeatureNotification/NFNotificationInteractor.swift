//
//  NFNotificationInteractor.swift
//  FeatureMain
//
//  Created by choijunios on 9/7/25.
//

import RIBs
import RxSwift
import UIKit

protocol NFNotificationRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol NFNotificationPresentable: Presentable {
    var listener: NFNotificationPresentableListener? { get set }
    
    func request(_ request: NFNotificationPresentableRequest)
}

enum NFNotificationPresentableRequest {
    case presentGuideImage(image: UIImage)
}

public protocol NFNotificationListener: AnyObject {
    func request(_ request: NFNotificationListenerRequest)
}

public enum NFNotificationListenerRequest {
    case dismiss
    case isPresentable(Bool)
}

final class NFNotificationInteractor: PresentableInteractor<NFNotificationPresentable>, NFNotificationInteractable, NFNotificationPresentableListener {
    
    private let model = NFNotificationModel()

    weak var router: NFNotificationRouting?
    weak var listener: NFNotificationListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: NFNotificationPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        listener?.request(.isPresentable(model.isShow))
    }
}


extension NFNotificationInteractor {
    func request(_ request: NFNotificationPresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            let image = model.getImage()
            presenter.request(.presentGuideImage(image: image))
            
        case .closeButtonTapped:
            model.checkWatchedToday()
            listener?.request(.dismiss)
            
        case .dontShowAgainButtonTapped:
            
            model.checkDontShowAgain()
            listener?.request(.dismiss)
            
        case .backgroundTapped:
            listener?.request(.dismiss)
        }
    }
}
