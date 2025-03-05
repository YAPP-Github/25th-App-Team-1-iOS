//
//  DockView.swift
//  Main
//
//  Created by choijunios on 1/29/25.
//

import UIKit

import FeatureResources

import SnapKit

final class DockView: UIView {
    
    // Sub
    private var dockLayer = CALayer()
    
    override var intrinsicContentSize: CGSize {
        .init(width: UIView.noIntrinsicMetric, height: 17)
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    required init?(coder: NSCoder) { nil }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let viewSize = self.layer.bounds.size
        let dockSize = CGSize(width: 36,height: 5)
        dockLayer.frame = .init(
            origin: .init(
                x: (viewSize.width-dockSize.width)/2,
                y: (viewSize.height-dockSize.height)/2
            ),
            size: dockSize
        )
        dockLayer.cornerRadius = dockSize.height/2
    }
    
    
    private func setupUI() {
        
        // self
        self.backgroundColor = .clear
        
        
        // dockLayer
        dockLayer.backgroundColor = R.Color.white10.cgColor
        self.layer.addSublayer(dockLayer)
    }
}
