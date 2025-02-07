//
//  ViewController.swift
//  ProjectDescriptionHelpers
//
//

import UIKit

class ViewController: UIViewController {
    override func loadView() {
        view = mainView
    }
    
    private let mainView = FortuneLetterView()
}
