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

final class SettingMainViewController: UIViewController, SettingMainPresentable, SettingMainViewControllable {

    weak var listener: SettingMainPresentableListener?
}
