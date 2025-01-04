//
//  MainViewController.swift
//  Orbit
//
//  Created by 손병근 on 1/4/25.
//

import RIBs
import RxSwift
import UIKit

protocol MainPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class MainViewController: UIViewController, MainPresentable, MainViewControllable {

    weak var listener: MainPresentableListener?
    
    override func viewDidLoad() {
        
    }
}
