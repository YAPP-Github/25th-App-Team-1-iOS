//
//  ExampleRIBViewController.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 3/4/25.
//

import RIBs
import RxSwift
import UIKit

import FeatureAlarmMission

import Then
import SnapKit

protocol ExampleRIBPresentableListener: AnyObject {
    func request(_ request: ExampleRIBPresentableListenerRequest)
}

enum ExampleRIBPresentableListenerRequest {
    case viewIsReady
    case cellIsTapped(index: Int)
}

final class ExampleRIBViewController: UIViewController, ExampleRIBPresentable, ExampleRIBViewControllable {

    typealias Cell = MissionCell
    
    weak var listener: ExampleRIBPresentableListener?
    
    // State
    private var items: [Mission] = []
    
    private let tableView = UITableView().then {
        $0.rowHeight = 65
        $0.register(Cell.self, forCellReuseIdentifier: String(describing: Cell.self))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        listener?.request(.viewIsReady)
    }
    
    func request(_ request: ExampleRIBPresenterRequest) {
        switch request {
        case .setItems(let items):
            self.items = items
            tableView.reloadData()
        }
    }
}


extension ExampleRIBViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: Cell.self)) as? Cell else { fatalError() }
        let item = items[indexPath.item]
        cell.label.text = "\(item)미션"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listener?.request(.cellIsTapped(index: indexPath.item))
    }
}
