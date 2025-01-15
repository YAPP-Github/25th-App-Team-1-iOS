//
//  InputSummaryViewController.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/15/25.
//

import RIBs
import RxSwift
import UIKit

protocol InputSummaryPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class InputSummaryViewController: UIViewController, InputSummaryPresentable, InputSummaryViewControllable {

    weak var listener: InputSummaryPresentableListener?
}
