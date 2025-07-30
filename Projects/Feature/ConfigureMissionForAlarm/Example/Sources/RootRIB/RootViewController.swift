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
import FeatureCommonEntity

protocol RootPresentableListener: AnyObject {
    func request(_ request: RootPresentableListenerRequest)
}

enum RootPresentableListenerRequest {
    case startButtonTapped(mission: Mission?)
}

final class RootViewController: UIViewController, RootPresentable, RootViewControllable {
    
    weak var listener: RootPresentableListener?
    
    
    // UI
    private let buttonWithNoMission: UIButton = .init()
    private let buttonWithMission: UIButton = .init()
    
    
    // Module
    private var router: ConfigureMissionForAlarmRouting?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        
        buttonWithNoMission.setTitle("미션 없는 상태 시작", for: .normal)
        buttonWithNoMission.setTitleColor(.black, for: .normal)
        buttonWithNoMission.setTitleColor(.gray, for: .focused)
        buttonWithNoMission.addTarget(self, action: #selector(onButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(buttonWithNoMission)
        
        
        buttonWithMission.setTitle("기본 미션 있는 상태 시작", for: .normal)
        buttonWithMission.setTitleColor(.black, for: .normal)
        buttonWithMission.setTitleColor(.gray, for: .focused)
        buttonWithMission.addTarget(self, action: #selector(onButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(buttonWithMission)
        
        
        buttonWithNoMission.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        buttonWithMission.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(buttonWithNoMission.snp.bottom).offset(10)
        }
    }
    
    @objc
    func onButtonTapped(_ sender: UIButton) {
        
        if sender === buttonWithMission {
            
            listener?.request(.startButtonTapped(mission: .default))
            
        } else if sender === buttonWithNoMission {
            
            listener?.request(.startButtonTapped(mission: nil))
        }
    }
}
