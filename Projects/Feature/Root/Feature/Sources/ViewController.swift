//
//  ViewController.swift
//  FeatureRoot
//
//  Created by choijunios on 12/28/24.
//

import UIKit

public class RootViewController: UIViewController {
    
    private let titleLabel: UILabel = .init()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    public required init?(coder: NSCoder) { nil }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        titleLabel.text = "Hello world"
        titleLabel.textColor = .black
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
