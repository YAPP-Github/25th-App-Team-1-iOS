//
//  ConfigureUserInfoInteractor.swift
//  FeatureSetting
//
//  Created by choijunios on 2/13/25.
//

import RIBs
import RxSwift

protocol ConfigureUserInfoRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ConfigureUserInfoPresentable: Presentable {
    var listener: ConfigureUserInfoPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ConfigureUserInfoListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ConfigureUserInfoInteractor: PresentableInteractor<ConfigureUserInfoPresentable>, ConfigureUserInfoInteractable, ConfigureUserInfoPresentableListener {

    weak var router: ConfigureUserInfoRouting?
    weak var listener: ConfigureUserInfoListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ConfigureUserInfoPresentable) {
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


// MARK: ConfigureUserInfoPresentableListener
extension ConfigureUserInfoInteractor {
    func request(_ request: ConfigureUserInfoPresenterRequest) {
        switch request {
        case .save:
            break
        case .back:
            break
        case .editName(let text):
            break
        case .editBirthDate:
            break
        case .editBornTime(let text):
            break
        case .editGender(let gender):
            break
        case .changeBornTimeUnknownState:
            break
        }
    }
}
