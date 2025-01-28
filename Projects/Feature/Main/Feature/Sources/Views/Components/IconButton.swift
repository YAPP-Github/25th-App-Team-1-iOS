//
//  IconButton.swift
//  Main
//
//  Created by choijunios on 1/28/25.
//

import UIKit

import FeatureDesignSystem

final class IconButton: TouchDetectingView {
    
    // Sub
    private var imageLayer: CALayer?
    
    var buttonAction: (() -> Void)?
    
    override var intrinsicContentSize: CGSize {
        .init(width: 32, height: 32)
    }
    
    init() { super.init(frame: .zero) }
    required init?(coder: NSCoder) { nil }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let selfSize = self.layer.bounds.size
        imageLayer?.frame = .init(
            origin: .init(x: 4, y: 4),
            size: .init(
                width: selfSize.width-8,
                height: selfSize.height-8
            )
        )
    }
    
    override func onTouchOut() {
        buttonAction?()
    }
    
    func update(image: UIImage) {
        imageLayer?.removeFromSuperlayer()
        let imageLayer = CALayer()
        imageLayer.contents = image.cgImage
        imageLayer.contentsGravity = .resizeAspect
        self.layer.addSublayer(imageLayer)
        self.imageLayer = imageLayer
        setNeedsLayout()
    }
}
