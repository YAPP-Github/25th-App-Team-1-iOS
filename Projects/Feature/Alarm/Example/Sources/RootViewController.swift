//
//  RootViewController.swift
//  FeatureAlarmExample
//
//  Created by ever on 12/29/24.
//

import UIKit
import RIBs

@testable import FeatureAlarm

final class RootViewController: UIViewController {
    enum Scene: CaseIterable {
        case alarmList
        case alarmSetting
        
        var title: String {
            switch self {
            case .alarmList: return "Alarm List"
            case .alarmSetting: return "Alarm Setting"
            }
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    var alarmListRouter: ViewableRouting?
    
    private func showAlarmList() {
        let builder = AlarmListBuilder(dependency: EmptyComponent())
        let router = builder.build(withListener: self)
        router.interactable.activate()
        alarmListRouter = router
        navigationController?.pushViewController(router.viewControllable.uiviewController, animated: true)
    }
    
    private func showAlarmSetting() {
        
    }
}

extension RootViewController: AlarmListListener {
    
}

extension EmptyComponent: AlarmListDependency {
    
}


extension RootViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Scene.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let scene = Scene.allCases[indexPath.section]
        cell.textLabel?.text = scene.title
        return cell
    }
}

extension RootViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Scene.allCases[indexPath.row] {
        case .alarmList:
            showAlarmList()
        case .alarmSetting:
            showAlarmSetting()
        }
    }
}
