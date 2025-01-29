//
//  MainPageView.swift
//  Main
//
//  Created by choijunios on 1/27/25.
//

import UIKit

import FeatureResources

import SnapKit
import Then
import Lottie

protocol MainPageViewListener: AnyObject {
    
    func action(_ action: MainPageView.Action)
}


final class MainPageView: UIView {
    
    // Action
    enum Action {
        case fortuneNotiButtonClicked
        case applicationSettingButtonClicked
    }
    
    
    // Listener
    weak var listener: MainPageViewListener?
    
    
    // Sub views
    // - Background
    private var backgroudCloudLayer: CALayer?
    private let hillView = UIView()
    
    private let orbitSpeechBubbleSpeech = SpeechBubbleView()
    private let orbitView = LottieAnimationView()
    
    // - Labels
    private let fortuneDeliveryTimeLabel: UILabel = .init()
    private let fortuneBaseLabel: UILabel = .init()
    private let fortuneLabelStack: UIStackView = .init().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 8
    }
    
    // - Buttons
    private let fortuneNotiButton: IconButton = .init()
    private let applicationSettingButton: IconButton = .init()
    private let toolButtonStack: UIStackView = .init().then {
        $0.axis = .horizontal
        $0.spacing = 12
    }
    
    private let fortuneDeliveredBubbleView: FortuneDeliveredBubbleView = .init()
    
    // - ResizableContentView
    private let resizableContentView = UIView()
    private let resizableContentViewDockView = DockView()
    private let resizableContentViewDockViewDrageArea = UIView()
    private let resizableContentViewDragRecognizer = UIPanGestureRecognizer()
    private var resizableContentViewScreenState: resizableContentViewScreenState = .half
    private var resizableContentViewTopConstraintWhenHalf: Constraint?
    private var resizableContentViewTopConstraintWhenFull: Constraint?
    
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
        
        if hillView.layer.sublayers == nil {
            setupHillView(ridgeHeight: 40)
        }
    }
}


// MARK: Setup
private extension MainPageView {
    
    func setupUI() {
        
        // self
        self.layer.backgroundColor = UIColor(hex: "#1F3B64").cgColor
        
        
        // hillView
        addSubview(hillView)
        
        
        // orbitSpeechBubbleView
        addSubview(orbitSpeechBubbleSpeech)
        
        
        // orbitView
        orbitView.loopMode = .playOnce
        addSubview(orbitView)
        
        
        // labels
        fortuneBaseLabel.numberOfLines = 0
        [fortuneDeliveryTimeLabel, fortuneBaseLabel].forEach {
            fortuneLabelStack.addArrangedSubview($0)
        }
        addSubview(fortuneLabelStack)
        
        
        // buttons
        // - set initial image
        fortuneNotiButton.update(image: FeatureResourcesAsset.letter.image)
        applicationSettingButton.update(image: FeatureResourcesAsset.settingsFill.image)
        // - button action
        fortuneNotiButton.buttonAction = { [weak self] in
            guard let self else { return }
            listener?.action(.fortuneNotiButtonClicked)
        }
        applicationSettingButton.buttonAction = { [weak self] in
            guard let self else { return }
            listener?.action(.applicationSettingButtonClicked)
        }
        [fortuneNotiButton, applicationSettingButton].forEach {
            toolButtonStack.addArrangedSubview($0)
        }
        addSubview(toolButtonStack)
        
        
        // fortuneDeliveredBubbleView
        fortuneDeliveredBubbleView.alpha = 0
        fortuneNotiButton.addSubview(fortuneDeliveredBubbleView)
        
        
        // ResizableContentView
        setupResizableContentViewUI()
    }
    
    
    func setupLayout() {
        
        // hillView
        hillView.snp.makeConstraints { make in
            make.top.equalTo(orbitView).inset(84)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        
        // orbitSpeechBubbleView
        orbitSpeechBubbleSpeech.snp.makeConstraints { make in
            make.bottom.equalTo(orbitView.snp.top)
            make.centerX.equalTo(orbitView)
        }
        
        
        // orbitView
        orbitView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(82)
            make.centerX.equalToSuperview()
            make.width.equalTo(140)
            make.height.equalTo(140)
        }
        
        
        // fortuneLabelStack
        fortuneLabelStack.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(orbitView.snp.bottom)
        }
        
        
        // buttonStack
        toolButtonStack.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(12.5)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-20)
        }
        
        
        // fortuneDeliveredBubbleView
        fortuneDeliveredBubbleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(fortuneNotiButton.snp.bottom).offset(2)
        }
        
        
        // ResizableContentView
        setupResizableContentViewLayout()
    }
}


// MARK: Backgroud
private extension MainPageView {
    
    func setupBackgroundLayout() {
        // Background cloud
        // - setupUI
        let backgroudCloudLayer = CALayer()
        backgroudCloudLayer.contents = FeatureResourcesAsset.mainPageBackSkyCloud.image.cgImage
        backgroudCloudLayer.contentsGravity = .resizeAspect
        self.layer.addSublayer(backgroudCloudLayer)
        // - setupLayout
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
        backgroudCloudLayer.zPosition = 0.1
    }
    
    
    func setupHillView(ridgeHeight: CGFloat) {
        // Shape layer
        let shapeLayer = CAShapeLayer()
        let hillWidth = hillView.bounds.width
        let hillHeight = hillView.bounds.height
        let cgPath = CGMutablePath()
        cgPath.move(to: .init(x: 0, y: ridgeHeight))
        cgPath.addQuadCurve(
            to: .init(x: hillWidth, y: ridgeHeight),
            control: .init(x: hillWidth/2, y: -ridgeHeight)
        )
        cgPath.addLine(to: .init(x: hillWidth, y: hillHeight))
        cgPath.addLine(to: .init(x: 0, y: hillHeight))
        cgPath.closeSubpath()
        shapeLayer.path = cgPath
        
        // Gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hex: "#172E51").cgColor,
            UIColor(hex: "#184385").cgColor,
        ]
        gradientLayer.startPoint = .init(x: 0.5, y: 0.0)
        gradientLayer.endPoint = .init(x: 0.5, y: 1.0)
        gradientLayer.mask = shapeLayer
        hillView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = hillView.layer.bounds
    }
}


// MARK: Public interface
extension MainPageView {
    
    enum UpdateRequest {
        case orbitState(OrbitRenderState)
        case fortuneDeliveryTimeText(String)
        case turnOnFortuneNoti(Bool)
        case turnOnFortuneIsDeliveredBubble(Bool)
    }
    
    @discardableResult func update(_ request: UpdateRequest) -> Self {
        switch request {
        case .orbitState(let orbitRenderState):
            updateOrbitState(orbitRenderState)
        case .fortuneDeliveryTimeText(let text):
            fortuneDeliveryTimeLabel.displayText = text.displayText(
                font: .label1Medium,
                color: R.Color.white70
            )
        case .turnOnFortuneNoti(let isOn):
            let notiIconImage = isOn ? FeatureResourcesAsset.letterNotificationOn.image : FeatureResourcesAsset.letter.image
            fortuneNotiButton.update(image: notiIconImage)
        case .turnOnFortuneIsDeliveredBubble(let isOn):
            fortuneDeliveredBubbleView.alpha = isOn ? 1 : 0
        }
        return self
    }
}


// MARK: Update orbit
private extension MainPageView {
    func updateOrbitState(_ state: OrbitRenderState) {
        // Orbit animation
        let animFilePath = state.orbitMotionLottieFilePath
        orbitView.animation = .filepath(animFilePath)
        orbitView.play()
        
        
        // Bubble text
        orbitSpeechBubbleSpeech.update(titleText: state.bubbleSpeechKorText)
        
        
        // Fortune base text
        fortuneBaseLabel.displayText = state.orbitFortuneBaseKorText.displayText(
            font: .heading2SemiBold,
            color: R.Color.white100
        )
        
        guard let attrStr = fortuneBaseLabel.attributedText else { return }
        let attrubute = attrStr.attribute(.paragraphStyle, at: 0, effectiveRange: nil)
        guard let paragraphStyle = attrubute as? NSParagraphStyle else { return }
        guard let mutableParagraphStyle = paragraphStyle.mutableCopy() as? NSMutableParagraphStyle else { return }
        mutableParagraphStyle.alignment = .center
        
        let mutableAttrStr = NSMutableAttributedString(attributedString: attrStr)
        mutableAttrStr.addAttribute(.paragraphStyle, value: mutableParagraphStyle, range: .init(location: 0, length: mutableAttrStr.length))
        fortuneBaseLabel.attributedText = mutableAttrStr
    }
}


// MARK: setup for ResizableContentView
private extension MainPageView {
    
    enum resizableContentViewScreenState {
        case full, half
    }
    
    enum ResizableContentViewConfig {
        // UI
        static let offsetFromBottomAnchorWhenHalf: CGFloat = 38
        static let drageAreaHeightBelowContainer: CGFloat = 80
        static let cornerRadiusWhenHalf: CGFloat = 16
        static let cornerRadiusWhenFull: CGFloat = 0
        
        // Anim
        static let transitionDuration: CGFloat = 0.35
        
        // Judgement
        static let minVelocityForFullScreen: CGFloat = -1200
        static let minVelocityForHalfScreen: CGFloat = 1200
    }
    
    
    func setupResizableContentViewUI() {
        
        // resizableContentView
        resizableContentView.backgroundColor = R.Color.gray900
        resizableContentView.layer.cornerRadius = ResizableContentViewConfig.cornerRadiusWhenHalf
        resizableContentView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.addSubview(resizableContentView)
        resizableContentView.layer.zPosition = 1
        
        
        // resizableContentViewDockView
        resizableContentView.addSubview(resizableContentViewDockView)
        
        
        // resizableContentViewDockViewDrageArea
        resizableContentViewDockViewDrageArea.backgroundColor = .clear
        resizableContentView.addSubview(resizableContentViewDockViewDrageArea)
        
        
        // setup gesture
        setupResizableContentViewDrag()
    }
    
    
    func setupResizableContentViewLayout() {
        
        // resizableContentView
        resizableContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            
            // When full
            resizableContentViewTopConstraintWhenFull = make.top.equalToSuperview()
                .constraint
            
            // When half
            resizableContentViewTopConstraintWhenHalf = make.top
                .equalTo(fortuneLabelStack.snp.bottom)
                .offset(ResizableContentViewConfig.offsetFromBottomAnchorWhenHalf)
                .constraint
        }
        resizableContentViewTopConstraintWhenFull?.deactivate()
        
        
        // resizableContentViewDockView
        resizableContentViewDockView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(resizableContentView.snp.top)
        }
        
        
        // resizableContentViewDockViewDrageArea
        resizableContentViewDockViewDrageArea.snp.makeConstraints { make in
            make.top.equalTo(resizableContentViewDockView)
            make.bottom.equalTo(resizableContentView.snp.top).offset(80)
            make.horizontalEdges.equalToSuperview()
            
            make.bottom.greaterThanOrEqualTo(self.safeAreaLayoutGuide.snp.top)
                .offset(ResizableContentViewConfig.drageAreaHeightBelowContainer)
                .priority(.high)
        }
    }
    
    
    func setupResizableContentViewDrag() {
        resizableContentViewDockViewDrageArea.addGestureRecognizer(resizableContentViewDragRecognizer)
        resizableContentViewDragRecognizer.addTarget(self, action: #selector(resizeDragOccurred(_:)))
    }
    
    
    @objc
    func resizeDragOccurred(_ recognizer: UIPanGestureRecognizer) {
        let panGestureVelocity = recognizer.velocity(in: self)
        if panGestureVelocity.y < ResizableContentViewConfig.minVelocityForFullScreen {
            // 풀스크린 변환 조건 충족
            if self.resizableContentViewScreenState == .half {
                resizableContentViewDragRecognizer.isEnabled = false
                self.resizableContentViewScreenState = .full
                UIView.animate(withDuration: ResizableContentViewConfig.transitionDuration) {
                    self.resizableContentView.layer.cornerRadius = ResizableContentViewConfig.cornerRadiusWhenFull
                    
                    // 레이아웃 조정
                    self.resizableContentViewTopConstraintWhenFull?.activate()
                    self.resizableContentViewTopConstraintWhenHalf?.deactivate()
                    

                    self.layoutIfNeeded()
                } completion: { _ in
                    self.resizableContentViewDragRecognizer.isEnabled = true
                }
            }
            return
        }
        
        
        if panGestureVelocity.y > ResizableContentViewConfig.minVelocityForHalfScreen {
            // 하프스크린 변환 조건 충족
            if self.resizableContentViewScreenState == .full {
                self.resizableContentViewScreenState = .half
                self.resizableContentViewDragRecognizer.isEnabled = false
                UIView.animate(withDuration: ResizableContentViewConfig.transitionDuration) {
                    self.resizableContentView.layer.cornerRadius = ResizableContentViewConfig.cornerRadiusWhenHalf
                    
                    // 레이아웃 조정
                    self.resizableContentViewTopConstraintWhenFull?.deactivate()
                    self.resizableContentViewTopConstraintWhenHalf?.activate()
                    
                    self.layoutIfNeeded()
                } completion: { _ in
                    self.resizableContentViewDragRecognizer.isEnabled = true
                }
            }
        }
        
    }
}
 

#Preview {
    MainPageView()
}
