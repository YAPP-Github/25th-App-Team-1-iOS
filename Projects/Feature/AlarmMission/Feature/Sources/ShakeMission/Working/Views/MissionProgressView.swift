//
//  MissionProgressView.swift
//  AlarmMission
//
//  Created by choijunios on 1/20/25.
//

import UIKit

import FeatureResources

final class MissionProgressView: UIView {
    
    // Sub layer
    private let stickLayer: CALayer = .init()
    
    
    // State
    private var progress: CGFloat
    
    
    override var intrinsicContentSize: CGSize {
        .init(width: UIView.noIntrinsicMetric, height: 5)
    }
    
    
    init(percent: CGFloat) {
        self.progress = percent
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // set frame
        stickLayer.frame = .init(
            origin: self.layer.bounds.origin,
            size: .init(
                width: self.layer.bounds.width*progress,
                height: self.layer.bounds.height
            )
        )
        
        // set cornerRadius
        self.layer.cornerRadius = self.layer.frame.height/2
        self.stickLayer.cornerRadius = self.layer.frame.height/2
    }
}


// MARK: Setup
extension MissionProgressView {
    
    func setupUI() {
        
        // self
        self.layer.backgroundColor = R.Color.white20.withAlphaComponent(0.2).cgColor
        
        // stickLayer
        stickLayer.backgroundColor = R.Color.main100.cgColor
        layer.addSublayer(stickLayer)
    }
    
    func setupLayout() { }
}


// MARK: Public interface
extension MissionProgressView {
    
    /// progress는 0.0~1.0사이 값이여야 유효합니다.
    func update(progress: CGFloat) {
        guard (0.0...1.0).contains(progress) else { fatalError() }
        
        self.progress = progress
        setNeedsLayout()
    }
}
