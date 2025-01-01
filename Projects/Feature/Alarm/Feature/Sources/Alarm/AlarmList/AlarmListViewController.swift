//
//  AlarmListViewController.swift
//  FeatureAlarmExample
//
//  Created by ever on 12/29/24.
//

import RIBs
import RxSwift
import UIKit

enum AlarmListPresentableListenerRequest {
    case addAlarm
}

protocol AlarmListPresentableListener: AnyObject {
    func request(_ request: AlarmListPresentableListenerRequest)
}

final class AlarmListViewController: UIViewController, AlarmListPresentable, AlarmListViewControllable {

    weak var listener: AlarmListPresentableListener?
    
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    private let mainView = AlarmListView()
}

extension AlarmListViewController: AlarmListViewListener {
    func action(_ action: AlarmListView.Action) {
        switch action {
        case .addButtonTapped:
            listener?.request(.addAlarm)
        }
    }
}
