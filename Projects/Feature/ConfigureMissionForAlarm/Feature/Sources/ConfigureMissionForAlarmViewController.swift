//
//  ConfigureMissionForAlarmViewController.swift
//  FeatureConfigureMissionForAlarm
//
//  Created by choijunios on 7/21/25.
//

import UIKit

import FeatureUIDependencies

import RIBs
import RxSwift

protocol ConfigureMissionForAlarmPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class ConfigureMissionForAlarmViewController: UIViewController, ConfigureMissionForAlarmPresentable, ConfigureMissionForAlarmViewControllable {

    weak var listener: ConfigureMissionForAlarmPresentableListener?
    
    // UI
    private let missionSelectionIntroView: MissionSelectionIntroView = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
    }
}


private extension ConfigureMissionForAlarmViewController {
    func setupUI() {
        
        // missionSelectionIntroView
        missionSelectionIntroView.listener = self
        view.addSubview(missionSelectionIntroView)
    }
    
    func setupLayout() {
        
        // missionSelectionIntroView
        missionSelectionIntroView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(212)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}


// MARK: MissionSelectionIntroViewListener
extension ConfigureMissionForAlarmViewController: MissionSelectionIntroViewListener {
    func request(_ action: MissionSelectionIntroViewAction) {
        switch action {
        case .addNewMission:
            break
        }
    }
}


#Preview(traits: .defaultLayout, body: {
    ConfigureMissionForAlarmViewController()
})
