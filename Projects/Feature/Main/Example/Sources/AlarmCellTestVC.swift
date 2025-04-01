//
//  AlarmCellTestVC.swift
//  Main
//
//  Created by choijunios on 3/28/25.
//

import UIKit

@testable import FeatureMain

import SnapKit

final class AlarmCellTestVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let alarmListView = UITableView()
    
    var alarms: [AlarmCellRO] = .init(
        repeating: .init(
            id: "text",
            alarmDays: .init(),
            meridiem: .am,
            hour: .init(5)!,
            minute: .init(12)!,
            isToggleOn: true,
            isChecked: false,
            mode: .idle
        ),
        count: 5
    )
    
    typealias Cell = AlarmCell
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAlarmTableView()
        
        alarmListView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let alarmCell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier) as? Cell else { fatalError() }
        let renderObject = alarms[indexPath.row]
        return alarmCell.update(renderObject: renderObject, animated: false)
    }
    
    func setupAlarmTableView() {
        // alarmTableView
        alarmListView.backgroundColor = .clear
        alarmListView.delegate = self
        alarmListView.dataSource = self
        alarmListView.rowHeight = 102
        alarmListView.separatorStyle = .singleLine
        alarmListView.separatorInset = .init(top:0,left:24,bottom:0,right: 24)
        alarmListView.contentInset = .init(top: 0, left: 0, bottom: 114, right: 0)
        alarmListView.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
        view.addSubview(alarmListView)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] (action, view, completionHandler) in
            guard let self else { return }
            
            completionHandler(true)
        }
        deleteAction.backgroundColor = .blue
        deleteAction.image = .init(systemName: "home")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        // Swipe to commit
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
