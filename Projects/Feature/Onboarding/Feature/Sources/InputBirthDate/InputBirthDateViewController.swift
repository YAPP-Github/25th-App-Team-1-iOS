//
//  InputBirthDateViewController.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/8/25.
//

import RIBs
import RxSwift
import UIKit

protocol InputBirthDatePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class InputBirthDateViewController: UIViewController, InputBirthDatePresentable, InputBirthDateViewControllable {

    weak var listener: InputBirthDayPresentableListener?
}
