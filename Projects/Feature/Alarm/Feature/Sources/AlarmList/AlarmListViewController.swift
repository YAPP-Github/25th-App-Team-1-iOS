//
//  AlarmListViewController.swift
//  FeatureAlarmExample
//
//  Created by ever on 12/29/24.
//

import RIBs
import RxSwift
import UIKit

protocol AlarmListPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class AlarmListViewController: UIViewController, AlarmListPresentable, AlarmListViewControllable {

    weak var listener: AlarmListPresentableListener?
    
    override func loadView() {
        view = mainView
    }
    
    private let mainView = AlarmListView()
}

extension AlarmListViewController: AlarmListViewListener {
    func action(_ action: AlarmListView.Action) {
        switch action {}
    }
}
