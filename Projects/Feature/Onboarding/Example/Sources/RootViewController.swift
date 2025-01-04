//
//  RootViewController.swift
//  FeatureOnboardingExample
//
//  Created by 손병근 on 1/4/25.
//

import RIBs
import UIKit
import FeatureOnboarding

final class RootViewController: UIViewController {
    enum Scene: CaseIterable {
        case intro
        case inputName
        
        var title: String {
            switch self {
            case .intro: return "소개페이지"
            case .inputName: return "이름 입력 화면"
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
    
    var rootRouter: Routing?
    
    private func showIntro() {
        let builder = RootBuilder(dependency: ExampleComponent(viewController: self))
        let router = builder.build(withListener: self, entryPoint: .intro)
        router.interactable.activate()
        rootRouter = router
    }
    
    private func showInputName() {
        let builder = RootBuilder(dependency: ExampleComponent(viewController: self))
        let router = builder.build(withListener: self, entryPoint: .inputName)
        router.interactable.activate()
        rootRouter = router
    }
}

extension RootViewController: RootListener, RootViewControllable {
    
}

extension ExampleComponent: RootDependency {
    var rootViewController: RootViewControllable {
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
        case .intro:
            showIntro()
        case .inputName:
            showInputName()
        }
    }
}

class ExampleComponent: Component<EmptyDependency> {
    let viewController: RootViewControllable
    init(viewController: RootViewControllable) {
        self.viewController = viewController
        super.init(dependency: EmptyComponent())
    }
}
