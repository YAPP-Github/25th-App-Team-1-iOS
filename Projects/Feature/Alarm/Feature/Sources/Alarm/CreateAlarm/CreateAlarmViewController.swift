//
//  CreateAlarmViewController.swift
//  FeatureAlarm
//
//  Created by ever on 12/30/24.
//

import RIBs
import RxSwift
import UIKit

enum CreateAlarmPresentableListenerRequest {
    case done
}

protocol CreateAlarmPresentableListener: AnyObject {
    func request(_ request: CreateAlarmPresentableListenerRequest)
}

final class CreateAlarmViewController: UIViewController, CreateAlarmPresentable, CreateAlarmViewControllable {

    weak var listener: CreateAlarmPresentableListener?
        
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    private let mainView = CreateAlarmView()
    
    private func setupNavigation() {
        title = "알람추가"
    }
}

extension CreateAlarmViewController: CreateAlarmViewListener {
    func action(_ action: CreateAlarmView.Action) {
        switch action {
        case .doneButtonTapped:
            listener?.request(.done)
        }
    }
}
