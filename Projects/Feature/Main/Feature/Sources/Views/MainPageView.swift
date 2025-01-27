//
//  MainPageView.swift
//  Main
//
//  Created by choijunios on 1/27/25.
//

import UIKit

import FeatureResources

protocol MainPageViewListener: AnyObject {
    
    func action(_ action: MainPageView.Action)
}


final class MainPageView: UIView {
    
    // Action
    enum Action {
        
        
    }
    
    
    // Listener
    weak var listener: MainPageViewListener?
    
    
    // Sub views
    // - Background
    private var backgroudCloudLayer: CALayer?
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if backgroudCloudLayer == nil {
            setupBackgroundLayout()
        }
    }
}


// MARK: Setup
private extension MainPageView {
    
    func setupUI() {
        
        // self
        self.layer.backgroundColor = UIColor(hex: "#1F3B64").cgColor
        
    }
    
    
    func setupLayout() {
        
        // Background
        // - backgroudCloudLayer
        
    }
    
    
    func setupBackgroundLayout() {
        // Background cloud
        let backgroudCloudLayer = CALayer()
        backgroudCloudLayer.contents = FeatureResourcesAsset.mainPageBackSkyCloud.image.cgImage
        backgroudCloudLayer.contentsGravity = .resizeAspect
        self.layer.addSublayer(backgroudCloudLayer)
        let imageSize = FeatureResourcesAsset.mainPageBackSkyCloud.image.size
        
        let imageRatio = imageSize.height / imageSize.width
        let screenSize = self.layer.bounds
        let preferedImageWidth = screenSize.width * 1.3
        let preferedImageSize = CGSize(
            width: preferedImageWidth,
            height: preferedImageWidth * imageRatio
        )
        let preferedImageX = -(preferedImageWidth - screenSize.width)/2
        backgroudCloudLayer.frame = .init(
            origin: .init(x: preferedImageX, y: 0),
            size: preferedImageSize
        )
        self.backgroudCloudLayer = backgroudCloudLayer
    }
}


#Preview {
    MainPageView()
}
