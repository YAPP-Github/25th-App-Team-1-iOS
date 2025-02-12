//
//  RootViewController.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/11/25.
//

import UIKit
import RIBs
import FeatureCommonDependencies
import FeatureUIDependencies

@testable import FeatureAlarmRelease

final class RootViewController: UIViewController {
    enum Scene: CaseIterable {
        case alarmRelease
        
        var title: String {
            switch self {
            case .alarmRelease: return "Alarm Release"
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
    
    let alarm: Alarm = Alarm(
        meridiem: .am,
        hour: .init(6)!,
        minute: .init(0)!,
        repeatDays: AlarmDays(),
        snoozeOption: .init(isSnoozeOn: true, frequency: .fiveMinutes, count: .fiveTimes),
        soundOption: .init(isVibrationOn: true, isSoundOn: true, volume: 0.7, selectedSound: R.AlarmSound.allCases.sorted(by: { $0.title < $1.title }).first?.title ?? "")
    )
    
    var alarmReleaseRouter: Routing?
    
    private func showAlarmRelease() {
        let builder = AlarmReleaseIntroBuilder(dependency: ExampleComponent(viewController: self))
        
        let router = builder.build(withListener: self, alarm: alarm)
        router.interactable.activate()
        alarmReleaseRouter = router
        router.interactable.activate()
        let navigationController = UINavigationController(rootViewController: router.viewControllable.uiviewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isNavigationBarHidden = true
        present(navigationController, animated: true)
    }
}

extension RootViewController: AlarmReleaseIntroListener, AlarmReleaseIntroViewControllable {
    func request(_ request: AlarmReleaseIntroListenerRequest) {
        switch request {
        case .releaseAlarm:
            guard let router = alarmReleaseRouter else { return }
            alarmReleaseRouter = nil
            router.interactable.deactivate()
            dismiss(animated: true)
        }
    }
}

extension ExampleComponent: AlarmReleaseIntroDependency {
    var alarmRootViewController: AlarmReleaseIntroViewControllable {
        viewController
    }
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
        case .alarmRelease:
            showAlarmRelease()
        }
    }
}

class ExampleComponent: Component<EmptyDependency> {
    let viewController: AlarmReleaseIntroViewControllable
    init(viewController: AlarmReleaseIntroViewControllable) {
        self.viewController = viewController
        super.init(dependency: EmptyComponent())
    }
}
