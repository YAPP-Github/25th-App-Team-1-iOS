//
//  SettingMainInteractor.swift
//  FeatureSetting
//
//  Created by choijunios on 2/13/25.
//

import RIBs
import RxSwift

protocol SettingMainRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SettingMainPresentable: Presentable {
    var listener: SettingMainPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SettingMainListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SettingMainInteractor: PresentableInteractor<SettingMainPresentable>, SettingMainInteractable, SettingMainPresentableListener {

    weak var router: SettingMainRouting?
    weak var listener: SettingMainListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SettingMainPresentable) {
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


// MARK: SettingMainPresentableListener
extension SettingMainInteractor {
    func request(_ request: SettingMainPresenterRequest) {
        switch request {
        case .executeSettingTask(let id):
            break
        case .presentConfigureUserInfo:
            break
        case .presentOpinionPage:
            break
        case .exitPage:
            break
        }
    }
}
