//
//  RootViewController.swift
//  FeatureMainExample
//
//  Created by ever on 2/7/25.
//

import UIKit
import RIBs

@testable import FeatureMain

final class RootViewController: UIViewController {
    enum Scene: CaseIterable {
        case main
        
        var title: String {
            switch self {
            case .main: return "Main"
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
    
    var mainRouter: Routing?
    
    private func showMain() {
        let builder = MainPageBuilder(dependency: ExampleComponent(viewController: self))
        let router = builder.build(withListener: self)
        router.interactable.activate()
        mainRouter = router
        router.viewControllable.uiviewController.modalPresentationStyle = .fullScreen
        present(router.viewControllable.uiviewController, animated: true)
    }
    
    private func showAlarmSetting() {
        
    }
}

extension RootViewController: MainPageListener, MainPageViewControllable {
    
}

extension ExampleComponent: MainPageDependency {
    var RootViewController: MainPageViewControllable {
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
        case .main:
            showMain()
        }
    }
}

class ExampleComponent: Component<EmptyDependency> {
    let viewController: MainPageViewControllable
    init(viewController: MainPageViewControllable) {
        self.viewController = viewController
        super.init(dependency: EmptyComponent())
    }
}

