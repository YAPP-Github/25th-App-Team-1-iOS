//
//  RoundBaseView.swift
//  ConfigureMissionForAlarm
//
//  Created by choijunios on 7/30/25.
//

import UIKit

import FeatureResources
import FeatureThirdPartyDependencies

final class RoundBaseView: UIView {
    
    private var contentsView: UIView?
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    required init?(coder: NSCoder) { nil }
    
    func change(contentsView: UIView, animated: Bool = false) {
        
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            
            if let prevView = self.contentsView {
                prevView.removeFromSuperview()
            }
            
            self.addSubview(contentsView)
            self.contentsView = contentsView
            contentsView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            if animated { self.layoutIfNeeded() }
        }
    }
    
    private func setupUI() {
        self.backgroundColor = R.Color.gray800
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.borderColor = R.Color.gray700.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 28
        self.layer.masksToBounds = true
    }
}
