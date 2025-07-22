//
//  RootViewController.swift
//  ConfigureMissionForAlarm
//
//  Created by choijunios on 7/22/25.
//

import UIKit

import FeatureConfigureMissionForAlarm

import SnapKit

final class RootViewController: UIViewController {
    
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
        let builder = ConfigureMissionForAlarmBuilder(
            dependency: ModuleDependency()
        )
        let router = builder.build(withListener: self)
        self.router = router
        
        self.present(
            router.viewControllable.uiviewController,
            animated: true
        )
    }
}

extension RootViewController: ConfigureMissionForAlarmListener {
    
}
