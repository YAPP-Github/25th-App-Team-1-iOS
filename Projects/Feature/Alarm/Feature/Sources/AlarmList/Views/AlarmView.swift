//
//  AlarmView.swift
//  FeatureAlarmExample
//
//  Created by ever on 12/29/24.
//

import UIKit

protocol AlarmListViewListener: AnyObject {
    func action(_ action: AlarmListView.Action)
}

final class AlarmListView: UIView {
    enum Action {
        
    }
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AlarmListView {
    func setupUI() {
        backgroundColor = .white
    }
    
    func layout() {
        
    }
}
