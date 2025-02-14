//
//  ConfigureUserInfoViewController.swift
//  FeatureSetting
//
//  Created by choijunios on 2/13/25.
//

import FeatureCommonEntity

import RIBs
import RxSwift
import UIKit

enum ConfigureUserInfoPresenterRequest {
    case save
    case back
    case editName(text: String)
    case editBirthDate
    case editBornTime(text: String)
    case editGender(gender: Gender)
    case changeBornTimeUnknownState
}

protocol ConfigureUserInfoPresentableListener: AnyObject {
    func request(_ request: ConfigureUserInfoPresenterRequest)
}

final class ConfigureUserInfoViewController: UIViewController, ConfigureUserInfoPresentable, ConfigureUserInfoViewControllable, ConfigureUserInfoViewListener {
    
    private var mainView: ConfigureUserInfoView!

    weak var listener: ConfigureUserInfoPresentableListener?
    
    override func loadView() {
        let mainView = ConfigureUserInfoView()
        mainView.listener = self
        self.mainView = mainView
        self.view = mainView
    }
}


// MARK: Public inteface
extension ConfigureUserInfoViewController {
    enum Update {
        
    }
    func update(_ update: Update) {
        
    }
}


// MARK: ConfigureUserInfoListener
extension ConfigureUserInfoViewController {
    func action(_ action: ConfigureUserInfoView.Action) {
        switch action {
        case .saveButtonTapped:
            listener?.request(.save)
        case .backButtonTapped:
            listener?.request(.back)
        case .nameTextChanged(let text):
            listener?.request(.editName(text: text))
        case .editBirthDateButtonTapped:
            listener?.request(.editBirthDate)
        case .genderButtonTapped(let gender):
            listener?.request(.editGender(gender: gender))
        case .bornTimeTextChanged(let text):
            listener?.request(.editBornTime(text: text))
        case .unknownBornTimeTapped:
            listener?.request(.changeBornTimeUnknownState)
        }
    }
}


#Preview {
    ConfigureUserInfoViewController()
}
