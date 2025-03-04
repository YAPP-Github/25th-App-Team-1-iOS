//
//  ShakeMissionWorkingView.swift
//  AlarmMission
//
//  Created by choijunios on 1/20/25.
//

import UIKit

import FeatureUIDependencies

protocol ShakeMissionWorkingViewListener: AnyObject {
    
    func action(_ action: ShakeMissionWorkingView.Action)
}

final class ShakeMissionWorkingView: UIView {
    
    // Action
    enum Action {
        case exitButtonClicked
        case missionGuideAnimationCompleted
        case missionSuccessAnimationCompleted
    }
    
    // Listener
    weak var listener: ShakeMissionWorkingViewListener?
    
    
    // Sub views
    private let exitButton: ExitButton = .init()
    private let missionProgressView: MissionProgressView = .init(percent: 0.0)
    private let amuletCardBackImage: UIImageView = .init().then {
        $0.image = FeatureResourcesAsset.shakeMissionWorkingAmuletBack.image
        $0.contentMode = .scaleAspectFit
    }
    
    // - Label
    private let labelStackView: UIStackView = .init().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }
    private let titleLabel: UILabel = .init()
    private let shakeCountLabel: UILabel = .init()
    
    // - Background
    private let backgroundView = MissionWorkingBackgroundView()
    
    // Mission start & complete view
    private var startMissionView: StartMissionView?
    private var missionCompleteView: MissionCompleteView?
    private let invisibleLayer = CALayer()
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // invisibleLayer
        invisibleLayer.frame = amuletCardBackImage.layer.frame
    }
}


// MARK: Setup
private extension ShakeMissionWorkingView {
    
    func setupUI() {
        // invisibleLayer
        layer.addSublayer(invisibleLayer)
        invisibleLayer.zPosition = 100
        
        
        // backgroundView
        addSubview(backgroundView)
        
        
        // exitButton
        exitButton.buttonAction = { [weak self] in
            guard let self else { return }
            listener?.action(.exitButtonClicked)
        }
        addSubview(exitButton)
        
        
        // missionProgressView
        missionProgressView.alpha = 0
        addSubview(missionProgressView)
        
        
        // labelStackView
        labelStackView.alpha = 0
        [titleLabel,shakeCountLabel].forEach({labelStackView.addArrangedSubview($0)})
        addSubview(labelStackView)
        
        
        // amuletCardImage
        addSubview(amuletCardBackImage)
    }
    
    func setupLayout() {
        // backgroundView
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        
        // exitButton
        exitButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(11)
            make.right.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        
        // missionProgressView
        missionProgressView.snp.makeConstraints { make in
            make.top.equalTo(exitButton.snp.bottom).offset(19)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        
        // labelStackView
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(missionProgressView.snp.bottom).offset(48)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        
        
        // amuletCardImage
        amuletCardBackImage.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        amuletCardBackImage.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        amuletCardBackImage.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom).offset(78)
            make.left.greaterThanOrEqualTo(self.safeAreaLayoutGuide).inset(92)
            make.right.lessThanOrEqualTo(self.safeAreaLayoutGuide).inset(92)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualTo(self.safeAreaLayoutGuide).priority(.required)
        }
    }
}


// MARK: Public interface
extension ShakeMissionWorkingView {
    
    enum MissionState {
        case guide
        case working
        case success
    }
    
    @discardableResult
    func update(missionState state: MissionState) -> Self {
        switch state {
        case .guide:
            let startMissionView = StartMissionView()
                .update(titleText: "흔들기 시작!")
            addSubview(startMissionView)
            startMissionView.snp.makeConstraints({ $0.edges.equalToSuperview() })
            self.startMissionView = startMissionView
            
            startMissionView.startShowUpAnimation() { [weak self] in
                guard let self else { return }
                finishGuide()
            }
            
        case .working:
            missionProgressView.alpha = 1
            labelStackView.alpha = 1
            startShakeGuideAnim()
            
        case .success:
            stopShakeGuideAnim()
            startZoomInAndFlipAnim()
            let shakeMissionCompleteView = MissionCompleteView()
            addSubview(shakeMissionCompleteView)
            shakeMissionCompleteView.layer.zPosition = 500
            shakeMissionCompleteView.snp.makeConstraints({ $0.edges.equalToSuperview() })
            self.missionCompleteView = shakeMissionCompleteView
            
            shakeMissionCompleteView.startShowUpAnimation(centeringView: amuletCardBackImage) { [weak self] in
                guard let self else { return }
                listener?.action(.missionSuccessAnimationCompleted)
            }
        }
        
        return self
    }
    
    
    @discardableResult
    func update(titleText: String) -> Self {
        self.titleLabel.displayText = titleText.displayText(
            font: .heading2SemiBold,
            color: R.Color.white100
        )
        return self
    }
    
    
    @discardableResult
    func update(countText: String) -> Self {
        self.shakeCountLabel.displayText = countText.displayText(
            font: .displaySemiBold,
            color: R.Color.white100
        )
        return self
    }
    
    
    @discardableResult
    /// 입력값 범위: 0.0...1.0
    func update(progress: Double) -> Self {
        self.missionProgressView.update(progress: progress)
        return self
    }
}


// MARK: Mission function
private extension ShakeMissionWorkingView {
    
    func finishGuide() {
        startMissionView?.removeFromSuperview()
        startMissionView = nil
        listener?.action(.missionGuideAnimationCompleted)
    }
    
    
    // MARK: Animation
    enum AnimationConfig {
        // Duration
        static let shakeGuideAnimDuration: Double = 1.75
        static let successZoomInAnimDuration: Double = 0.3
        static let successFlipAnimDuration: Double = 0.3
        
        // Value
        static let successZoomInValue: Double = 1.25
    }
    
    // - Shake amulet animation
    func startShakeGuideAnim() {
        if amuletCardBackImage.layer.animation(forKey: "shake_guide") != nil { return }
        let guideAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        guideAnimation.values = [0,(CGFloat.pi/180)*10,0,0,-(CGFloat.pi/180)*10,0]
        guideAnimation.keyTimes = [0.1,0.2,0.4,0.5,0.65,1.0]
        guideAnimation.duration = AnimationConfig.shakeGuideAnimDuration
        guideAnimation.repeatCount = .infinity
        amuletCardBackImage.layer.add(guideAnimation, forKey: "shake_guide")
    }
    
    func stopShakeGuideAnim() {
        guard amuletCardBackImage.layer.animation(forKey: "shake_guide") != nil else { return }
        amuletCardBackImage.layer.removeAnimation(forKey: "shake_guide")
    }
    
    
    // - Zoom in & Flips animation
    func startZoomInAndFlipAnim() {
        let zoomInAnim = CABasicAnimation(keyPath: "transform.scale")
        zoomInAnim.fromValue = 1.0
        zoomInAnim.toValue = AnimationConfig.successZoomInValue
        zoomInAnim.duration = AnimationConfig.successZoomInAnimDuration
        zoomInAnim.fillMode = .forwards
        zoomInAnim.isRemovedOnCompletion = false
        amuletCardBackImage.layer.add(zoomInAnim, forKey: "success_zoom_in")
        
        DispatchQueue.main.asyncAfter(deadline: .now()+AnimationConfig.successZoomInAnimDuration) { [weak self] in
            guard let self else { return }
            
            let amuletCardBackImageLayer = createAmuletBackLayer()
            amuletCardBackImageLayer.zPosition = 50
            amuletCardBackImage.alpha = 0
            
            let flipAnim1 = CABasicAnimation(keyPath: "transform.rotation.y")
            flipAnim1.fromValue = 0
            flipAnim1.toValue = CGFloat.pi/2
            flipAnim1.duration = AnimationConfig.successFlipAnimDuration
            flipAnim1.fillMode = .forwards
            flipAnim1.isRemovedOnCompletion = false
            amuletCardBackImageLayer.add(flipAnim1, forKey: "success_flip")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+AnimationConfig.successZoomInAnimDuration+AnimationConfig.successFlipAnimDuration) { [weak self] in
            guard let self else { return }
            
            let amuletCardFrontImageLayer = createAmuletFrontLayer()
            amuletCardFrontImageLayer.zPosition = 300
            let flipAnim2 = CABasicAnimation(keyPath: "transform.rotation.y")
            flipAnim2.fromValue = CGFloat.pi*2 * 3/4
            flipAnim2.toValue = CGFloat.pi*2
            flipAnim2.duration = AnimationConfig.successFlipAnimDuration
            flipAnim2.fillMode = .forwards
            flipAnim2.isRemovedOnCompletion = false
            amuletCardFrontImageLayer.add(flipAnim2, forKey: "success_flip")
        }
    }
    
    func createAmuletBackLayer() -> CALayer {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let imageLayer = CALayer()
        invisibleLayer.addSublayer(imageLayer)
        imageLayer.frame = invisibleLayer.bounds
        imageLayer.contents = FeatureResourcesAsset.shakeMissionWorkingAmuletBack.image.cgImage
        imageLayer.contentsGravity = .resizeAspect
        imageLayer.setAffineTransform(.init(
            scaleX: AnimationConfig.successZoomInValue,
            y: AnimationConfig.successZoomInValue
        ))
        CATransaction.commit()
        return imageLayer
    }
    
    private func createAmuletFrontLayer() -> CALayer {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let imageLayer = CALayer()
        self.invisibleLayer.addSublayer(imageLayer)
        imageLayer.frame = invisibleLayer.bounds
        imageLayer.contents = FeatureResourcesAsset.shakeMissionWorkingAmuletFront.image.cgImage
        imageLayer.contentsGravity = .resizeAspect
        imageLayer.setAffineTransform(.init(
            scaleX: AnimationConfig.successZoomInValue,
            y: AnimationConfig.successZoomInValue
        ))
        CATransaction.commit()
        return imageLayer
    }
}
