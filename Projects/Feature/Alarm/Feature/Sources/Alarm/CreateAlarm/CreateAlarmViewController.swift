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
    case meridiemChanged(Meridiem)
    case hourChanged(Int)
    case minuteChanged(Int)
    case done
}

protocol CreateAlarmPresentableListener: AnyObject {
    func request(_ request: CreateAlarmPresentableListenerRequest)
}

final class CreateAlarmViewController: UIViewController, CreateAlarmPresentable, CreateAlarmViewControllable {

    weak var listener: CreateAlarmPresentableListener?
        
    override func loadView() {
        view = mainView
        mainView.listener = self
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
        case let .meridiemChanged(meridiem):
            listener?.request(.meridiemChanged(meridiem))
        case let .hourChanged(hour):
            listener?.request(.hourChanged(hour))
        case let .minuteChanged(minute):
            listener?.request(.minuteChanged(minute))
        case .doneButtonTapped:
            listener?.request(.done)
        }
    }
}
