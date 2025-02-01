//
//  MainPageView.swift
//  Main
//
//  Created by choijunios on 1/27/25.
//

import UIKit

import FeatureResources
import FeatureDesignSystem

import SnapKit
import Then
import Lottie

protocol MainPageViewListener: AnyObject {
    func action(_ action: MainPageView.Action)
}


final class MainPageView: UIView, UITableViewDelegate, AlarmCellListener {
    
    // Action
    enum Action {
        case fortuneNotiButtonClicked
        case applicationSettingButtonClicked
        case alarmStateWillChange(alarmId: String, isActive: Bool)
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
    private let fortuneNotiButton: DSDefaultIconButton = .init(style: .init(
        type: .default,
        image: FeatureResourcesAsset.letter.image,
        size: .small
    ))
    private let applicationSettingButton: DSDefaultIconButton = .init(style: .init(
        type: .default,
        image: FeatureResourcesAsset.settingsFill.image,
        size: .small
    ))
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
    
    // - Alarm
    private let alarmToolBarTitleLabel: UILabel = .init()
    private let addAlarmButton: DSDefaultIconButton = .init(style: .init(
        type: .default,
        image: FeatureResourcesAsset.plus.image,
        size: .small
    ))
    private let configAlarmButton: DSDefaultIconButton = .init(style: .init(
        type: .default,
        image: FeatureResourcesAsset.more.image,
        size: .small
    ))
    private let alarmToolBarButtonStack: UIStackView = .init().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
    private let alarmToolBarContainerStack: UIStackView = .init().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    private let alarmToolBarContainerView: UIView = .init()
    
    // - TableView
    private let alarmTableView: UITableView = .init()
    private var alarmTableDiffableDataSource: UITableViewDiffableDataSource<Int, String>!
    private var alarmCellROs: [AlarmCellRO] = []
    
    
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
        
        
        // resizableContentView
        resizableContentView.backgroundColor = R.Color.gray900
        resizableContentView.layer.cornerRadius = ResizableContentViewConfig.cornerRadiusWhenHalf
        resizableContentView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.addSubview(resizableContentView)
        resizableContentView.layer.zPosition = 1
        
        
        // resizableContentViewDockView
        resizableContentView.addSubview(resizableContentViewDockView)
        
        
        // alarmToolBar
        alarmToolBarTitleLabel.displayText = "알림".displayText(
            font: .heading2SemiBold,
            color: R.Color.white100
        )
        
        
        // alarmToolBarButtonStack
        [addAlarmButton, configAlarmButton].forEach {
            alarmToolBarButtonStack.addArrangedSubview($0)
        }
        
        
        // alarmToolBarContainerStack
        [alarmToolBarTitleLabel, UIView(), alarmToolBarButtonStack].forEach {
            alarmToolBarContainerStack.addArrangedSubview($0)
        }
        alarmToolBarContainerView.addSubview(alarmToolBarContainerStack)
        
        
        // alarmToolBarContainerView
        resizableContentView.addSubview(alarmToolBarContainerView)
        
        
        // resizableContentViewDockViewDrageArea
        resizableContentViewDockViewDrageArea.backgroundColor = .clear
        resizableContentView.addSubview(resizableContentViewDockViewDrageArea)
        setupResizableContentViewDrag()
        
        
        // alarmTableView
        setupAlarmTableView()
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
        
        
        // alarmToolBarContainerStack
        alarmToolBarContainerStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(16)
        }
        
        
        // alarmToolBarContainerView
        alarmToolBarContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
                .priority(.high)
            make.top.greaterThanOrEqualTo(self.safeAreaLayoutGuide)
                .inset(14)
                .priority(.required)
            make.horizontalEdges.equalToSuperview()
        }
        
        
        // alarmTableView
        alarmTableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(alarmToolBarContainerView.snp.bottom)
            make.bottom.equalToSuperview()
        }
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
        case presentAlarmCell(list: [AlarmCellRO])
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
        case .presentAlarmCell(let list):
            presentAlarmROs(list)
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
        static let drageAreaOffsetOverDock: CGFloat = 50
        static let cornerRadiusWhenHalf: CGFloat = 16
        static let cornerRadiusWhenFull: CGFloat = 0
        
        // Anim
        static let transitionDuration: CGFloat = 0.35
        
        // Judgement
        static let minVelocityForFullScreen: CGFloat = -1200
        static let minVelocityForHalfScreen: CGFloat = 1200
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
                .offset(-ResizableContentViewConfig.drageAreaOffsetOverDock)
            make.bottom.equalTo(alarmToolBarContainerView.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.greaterThanOrEqualTo(self.safeAreaLayoutGuide.snp.top)
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


// MARK: TableView
extension MainPageView {
    typealias Cell = AlarmCell
    
    func presentAlarmROs(_ ros: [AlarmCellRO]) {
        self.alarmCellROs = ros
        let identifiers = ros.map({ $0.id })
        var snapShot = NSDiffableDataSourceSnapshot<Int, String>()
        snapShot.appendSections([0])
        snapShot.appendItems(identifiers)
        self.alarmTableDiffableDataSource.apply(snapShot)
    }
    
    func setupAlarmTableView() {
        // alarmTableDiffableDataSource
        let diffableDataSource = UITableViewDiffableDataSource<Int, String>(
            tableView: alarmTableView) { [weak self] tableView, indexPath, itemIdentifier in
                guard let self, let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier) as? Cell else { fatalError() }
                let renderObject = alarmCellROs[indexPath.item]
                return cell.update(renderObject: renderObject)
            }
        self.alarmTableDiffableDataSource = diffableDataSource
        
        // alarmTableView
        alarmTableView.backgroundColor = .clear
        alarmTableView.delegate = self
        alarmTableView.dataSource = diffableDataSource
        alarmTableView.rowHeight = UIView.noIntrinsicMetric
        alarmTableView.estimatedRowHeight = 102
        alarmTableView.separatorStyle = .singleLine
        alarmTableView.separatorColor = R.Color.gray800
        alarmTableView.separatorInset = .init(top:0,left:24,bottom:0,right: 24)
        alarmTableView.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
        resizableContentView.addSubview(alarmTableView)
    }
}


// MARK: AlarmCellListener
extension MainPageView {
    func action(_ action: AlarmCell.Action) {
        switch action {
        case .toggleIsTapped(let cellId, let willMoveTo):
            listener?.action(.alarmStateWillChange(
                alarmId: cellId,
                isActive: (willMoveTo == .active)
            ))
        }
    }
}
 

#Preview {
    MainPageView()
}
