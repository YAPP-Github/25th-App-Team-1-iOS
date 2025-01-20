//
//  DSTwoButtonAlertViewController.swift
//  FeatureDesignSystem
//
//  Created by choijunios on 1/20/25.
//

import UIKit

public protocol DSTwoButtonAlertViewControllerListener: AnyObject {
    
    func action(_ action: DSTwoButtonAlertViewController.Action)
}

public class DSTwoButtonAlertViewController: UIViewController {
    
    // Action
    public enum Action {
        case leftButtonClicked
        case rightButtonClicked
    }
    
    // Listener
    public weak var listener: DSTwoButtonAlertViewControllerListener?
    
    
    // Sub views
    private let alertView: DSTwoButtonAlert = .init()
    
    
    // Config
    public let config: Config
    
    
    public init(config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { nil }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        
        // view
        view.backgroundColor = UIColor(hex: "#17191F").withAlphaComponent(0.9)
        
        // alertView
        alertView
            .update(titleText: config.titleText)
            .update(subTitleText: config.subTitleText)
        alertView.leftButton.update(title: config.leftButtonText)
        alertView.rightButton.update(title: config.rightButtonText)
        alertView.leftButton.buttonAction = { [weak self] in
            self?.listener?.action(.leftButtonClicked)
        }
        alertView.rightButton.buttonAction = { [weak self] in
            self?.listener?.action(.rightButtonClicked)
        }
        view.addSubview(alertView)
    }
    
    private func setupLayout() {
        
        // alertView
        alertView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(33.5)
        }
    }
}


// MARK: Configuration
public extension DSTwoButtonAlertViewController {
    
    struct Config {
        let titleText: String
        let subTitleText: String
        let leftButtonText: String
        let rightButtonText: String
        
        public init(titleText: String, subTitleText: String, leftButtonText: String, rightButtonText: String) {
            self.titleText = titleText
            self.subTitleText = subTitleText
            self.leftButtonText = leftButtonText
            self.rightButtonText = rightButtonText
        }
    }
}


#Preview {
    DSTwoButtonAlertViewController(config: .init(
        titleText: "이것은 타이틀 입니다.",
        subTitleText: "이것은 서브타이틀 입니다.",
        leftButtonText: "왼쪽",
        rightButtonText: "오른쪽"
    ))
}
