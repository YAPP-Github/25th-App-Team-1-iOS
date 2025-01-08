//
//  InputBirthDayViewController.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/8/25.
//

import RIBs
import RxSwift
import UIKit

protocol InputBirthDayPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class InputBirthDayViewController: UIViewController, InputBirthDayPresentable, InputBirthDayViewControllable {

    weak var listener: InputBirthDayPresentableListener?
}
