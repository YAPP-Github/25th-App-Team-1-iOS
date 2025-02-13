//
//  SettingMainViewController.swift
//  FeatureSetting
//
//  Created by choijunios on 2/13/25.
//

import RIBs
import RxSwift
import UIKit

enum SettingMainPresenterRequest {
    case executeSettingTask(id: String)
    case presentConfigureUserInfo
    case presentOpinionPage
    case exitPage
}

protocol SettingMainPresentableListener: AnyObject {
    func request(_ request: SettingMainPresenterRequest)
}

final class SettingMainViewController: UIViewController, SettingMainPresentable, SettingMainViewControllable, SettingMainViewListener {
    // Sub view
    private var mainView: SettingMainView!

    weak var listener: SettingMainPresentableListener?
    
    override func loadView() {
        let mainView = SettingMainView()
        mainView.listener = self
        self.mainView = mainView
        self.view = mainView
    }
}


// MARK: Public interface
extension SettingMainViewController {
    enum Update {
        case setUserInfo(UserInfoCardRO)
        case setSettingSection([SettingSectionRO])
    }
    func update(_ update: Update) {
        switch update {
        case .setSettingSection(let sectionROs):
            mainView.update(.sections(sections: sectionROs))
        case .setUserInfo(let infoRO):
            mainView.update(.userInfoCard(userInfo: infoRO))
        }
    }
}


// MARK: SettingMainViewListener
extension SettingMainViewController {
    func action(_ action: SettingMainView.Action) {
        switch action {
        case .settingItemIsTapped(let id):
            listener?.request(.executeSettingTask(id: id))
        case .opinionButtonTapped:
            listener?.request(.presentOpinionPage)
        case .userInfoCardTapped:
            listener?.request(.presentConfigureUserInfo)
        case .backButtonTapped:
            listener?.request(.exitPage)
        }
    }
}


#Preview {
    let vc = SettingMainViewController()
    vc.loadView()
    return vc
}
