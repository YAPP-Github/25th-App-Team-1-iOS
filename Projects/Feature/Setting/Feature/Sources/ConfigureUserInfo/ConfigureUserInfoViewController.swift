//
//  ConfigureUserInfoViewController.swift
//  FeatureSetting
//
//  Created by choijunios on 2/13/25.
//

import RIBs
import RxSwift
import UIKit

protocol ConfigureUserInfoPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
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


// MARK: ConfigureUserInfoListener
extension ConfigureUserInfoViewController {
    func action(_ action: ConfigureUserInfoView.Action) {
        
    }
}


#Preview {
    ConfigureUserInfoViewController()
}
