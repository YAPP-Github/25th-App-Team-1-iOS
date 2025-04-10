//
//  RootViewController.swift
//  FeatureOnboardingExample
//
//  Created by 손병근 on 1/4/25.
//

import FeatureLogger
import FeatureOnboarding

import RIBs
import UIKit

final class RootViewController: UIViewController {
    enum Scene: CaseIterable {
        case intro
        case inputName
        case inputBornTime
        case inputGender
        case inputWakeUpAlarm
        case inputBirthDate
        case authorizationRequest
        
        var title: String {
            switch self {
            case .intro: return "소개페이지"
            case .inputName: return "이름 입력 화면"
            case .inputBornTime: return "태어난 시간 입력 화면"
            case .inputGender: return "성별 입력 화면"
            case .inputWakeUpAlarm: return "알람 시간 입력 화면"
            case .inputBirthDate: return "생일 입력 화면"
            case .authorizationRequest: return "권한 요청 화면"
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
    
    private func showInputBornTIme() {
        let builder = RootBuilder(dependency: ExampleComponent(viewController: self))
        let router = builder.build(withListener: self, entryPoint: .inputBornTime)
        router.interactable.activate()
        rootRouter = router
    }
    
    private func showInputGender() {
        let builder = RootBuilder(dependency: ExampleComponent(viewController: self))
        let router = builder.build(withListener: self, entryPoint: .inputGender)
        router.interactable.activate()
        rootRouter = router
    }
    
    private func showInputWakeUpAlarm() {
        let builder = RootBuilder(dependency: ExampleComponent(viewController: self))
        let router = builder.build(withListener: self, entryPoint: .inputWakeUpAlarm)
        router.interactable.activate()
        rootRouter = router
    }
    private func showInputBirthDate() {
        let builder = RootBuilder(dependency: ExampleComponent(viewController: self))
        let router = builder.build(withListener: self, entryPoint: .inputBirthDate)
        router.interactable.activate()
        rootRouter = router
    }
    
    private func showAuthorizationRequest() {
        let builder = RootBuilder(dependency: ExampleComponent(viewController: self))
        let router = builder.build(withListener: self, entryPoint: .authorizationRequest)
        router.interactable.activate()
        rootRouter = router
    }
}

extension RootViewController: RootListener, RootViewControllable {
    func request(_ request: FeatureOnboarding.RootListenerRequest) {
        
    }
}

extension ExampleComponent: RootDependency {
    var onboardingRootViewController: RootViewControllable {
        viewController
    }
    
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
        let scene = Scene.allCases[indexPath.row]
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
        case .inputBornTime:
            showInputBornTIme()
        case .inputGender:
            showInputGender()
        case .inputWakeUpAlarm:
            showInputWakeUpAlarm()
        case .inputBirthDate:
            showInputBirthDate()
        case .authorizationRequest:
            showAuthorizationRequest()
        }
    }
}

class ExampleComponent: Component<EmptyDependency> {
    let viewController: RootViewControllable
    let logger: Logger
    init(viewController: RootViewControllable, logger: Logger = PrintOnlyLogger()) {
        self.viewController = viewController
        self.logger = logger
        super.init(dependency: EmptyComponent())
    }
}
