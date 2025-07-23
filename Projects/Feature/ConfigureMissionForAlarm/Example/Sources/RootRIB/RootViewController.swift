//
//  RootViewController.swift
//  FeatureConfigureMissionForAlarm
//
//  Created by choijunios on 7/22/25.
//

import RIBs
import RxSwift
import UIKit

import FeatureConfigureMissionForAlarm

protocol RootPresentableListener: AnyObject {
    func request(_ request: RootPresentableListenerRequest)
}

enum RootPresentableListenerRequest {
    case startButtonTapped
}

final class RootViewController: UIViewController, RootPresentable, RootViewControllable {
    
    weak var listener: RootPresentableListener?
    
    
    // UI
    private let button: UIButton = .init()
    
    
    // Module
    private var router: ConfigureMissionForAlarmRouting?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        
        button.setTitle("시작", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .focused)
        button.addTarget(self, action: #selector(onButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
        
        
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc
    func onButtonTapped(_ sender: UIButton) {
        listener?.request(.startButtonTapped)
    }
}
