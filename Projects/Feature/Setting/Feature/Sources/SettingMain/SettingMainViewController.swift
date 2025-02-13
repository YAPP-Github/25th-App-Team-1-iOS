//
//  SettingMainViewController.swift
//  FeatureSetting
//
//  Created by choijunios on 2/13/25.
//

import RIBs
import RxSwift
import UIKit

protocol SettingMainPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
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


// MARK: SettingMainViewListener
extension SettingMainViewController {
    func action(_ action: SettingMainView.Action) {
        switch action {
        case .settingItemIsTapped(let rowId):
            break
        case .opinionButtonTapped:
            break
        case .userInfoCardTapped:
            break
        case .backButtonTapped:
            break
        }
    }
}


#Preview {
    let vc = SettingMainViewController()
    vc.loadView()
    return vc
}
