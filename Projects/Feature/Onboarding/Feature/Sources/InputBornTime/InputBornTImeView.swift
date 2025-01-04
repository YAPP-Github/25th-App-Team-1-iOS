//
//  InputBornTImeView.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import UIKit
import SnapKit
import Then
import FeatureResources

protocol InputBornTImeViewListener: AnyObject {
    func action(_ action: InputBornTImeView.Action)
}

final class InputBornTImeView: UIView {
    enum Action {
        case timeChanged(String)
        case iDontKnowButtonTapped
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var listener: InputBornTImeViewListener?
}

private extension InputBornTImeView {
    func setupUI() {
        backgroundColor = R.Color.gray900
    }
    
    func layout() {
        
    }
}
