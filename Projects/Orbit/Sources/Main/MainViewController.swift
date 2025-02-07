//
//  MainViewController.swift
//  Orbit
//
//  Created by 손병근 on 1/4/25.
//

import RIBs
import RxSwift
import UIKit
import FeatureThirdPartyDependencies

protocol MainPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class MainViewController: UIViewController, MainPresentable, MainViewControllable {

    weak var listener: MainPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        layout()
    }
    
    private let logoImageView = UIImageView()
}

private extension MainViewController {
    func setupUI() {
        logoImageView.do {
            $0.image = UIImage(named: "splash_logo")
            $0.contentMode = .scaleAspectFit
        }
        view.addSubview(logoImageView)
    }
    
    func layout() {
        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
