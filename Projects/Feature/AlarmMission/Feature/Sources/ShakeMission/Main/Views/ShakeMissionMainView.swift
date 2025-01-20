//
//  ShakeMissionMainView.swift
//  AlarmMission
//
//  Created by choijunios on 1/20/25.
//

import UIKit

protocol ShakeMissionMainViewListener: AnyObject {
    
    func action(_ action: ShakeMissionMainView.Action)
}

class ShakeMissionMainView: UIView {
    
    // Action
    enum Action {
        
    }
    
    
    // Listener
    weak var listener: ShakeMissionMainViewListener?
    
    
    init() {
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { nil }
}
