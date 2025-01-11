//
//  AuthorizationRequestViewController.swift
//  FeatureOnboarding
//
//  Created by ever on 1/11/25.
//

import RIBs
import RxSwift
import UIKit

protocol AuthorizationRequestPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class AuthorizationRequestViewController: UIViewController, AuthorizationRequestPresentable, AuthorizationRequestViewControllable {

    weak var listener: AuthorizationRequestPresentableListener?
}
