//
//  ViewController.swift
//  ProjectDescriptionHelpers
//
//

import UIKit
import FeatureUIDependencies

class ViewController: UIViewController {
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        if let navBar = navigationController?.navigationBar {
            navBar.setBackgroundImage(UIImage(), for: .default)
            navBar.shadowImage = UIImage()
            navBar.isTranslucent = true
            navBar.backgroundColor = .clear
            navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
        
        title = "미래에서 온 편지"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: FeatureResourcesAsset.svgNavClose.image.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(closeButtonTapped))
    }
    
    private let mainView = FortuneCoordinationView()
    
    @objc
    private func closeButtonTapped() {
        
    }
}
