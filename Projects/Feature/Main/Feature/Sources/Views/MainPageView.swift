//
//  MainPageView.swift
//  Main
//
//  Created by choijunios on 1/27/25.
//

import UIKit
import FeatureUIDependencies
import FeatureThirdPartyDependencies
import FeatureCommonDependencies
import Lottie

protocol MainPageViewListener: AnyObject {
    func action(_ action: MainPageView.Action)
}


final class MainPageView: UIView, DeleteAlarmGroupBarViewListener {
    
    // Action
    enum Action {
        case screenWithoutAlarmConfigureViewTapped
        
        case fortuneNotiButtonClicked
        case applicationSettingButtonClicked
        case addAlarmButtonClicked
        case configureAlarmListButtonClicked
        
        case alarmCellIsTapped(alarmId: String)
        case alarmActivityStateWillChange(alarmId: String)
        case alarmIsCheckedForDeletion(alarmId: String)
        case alarmCellWillDelete(alarmId: String)
        case alarmCellIsLongPressed(alarmId: String)
        case singleAlarmDeletionViewBackgroundTapped
        
        case alarmsWillDelete
        case changeModeToDeletionButtonClicked
        case changeModeToIdleButtonClicked
        case deleteAllAlarmCheckBoxTapped
    }
    
    
    // Listener
    weak var listener: MainPageViewListener?
    
    
    // Sub views
    // - Background
    private var backgroudCloudLayer: CALayer?
    private let hillView = UIView()
    
    private let orbitSpeechBubbleSpeech = SpeechBubbleView()
    private let orbitLottieView = LottieAnimationView()
    private let orbitImageView = UIImageView()
    
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
    private let configureAlarmButton: DSSelectableIconButton = .init(
        initialState: .idle,
        style: .init(
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
    
    // - AlarmListView
    private let alarmListView: UITableView = .init()
    private var alarmCellRenderObjects: [AlarmCellRO] = []
    
    // - AlarmDeletionView
    private var alarmDeletionView: AlarmDeletionView?
    
    // - alarmOptionBottomListView
    private var alarmOptionBottomListView: UIView?
    
    // - DeleteAlarmGroup
    private let deleteAlarmGroupBarView: DeleteAlarmGroupBarView = .init()
    private let deleteGroupAlarmConfirmButton: DSDefaultCTAButton = .init(
        initialState: .active,
        style: .init(
            type: .tertiary,
            size: .large,
            cornerRadius: .large
    ))
    
    
    // Gesture
    private let screenTapGesture = UITapGestureRecognizer()
        
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
        setupGesture()
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
        
        
        // orbitLottieView
        orbitLottieView.loopMode = .loop
        addSubview(orbitLottieView)
        orbitLottieView.alpha = 0
        
        
        // orbitImageView
        orbitImageView.contentMode = .scaleAspectFit
        addSubview(orbitImageView)
        orbitImageView.alpha = 0
        
        
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
        alarmToolBarTitleLabel.displayText = "알람".displayText(
            font: .heading2SemiBold,
            color: R.Color.white100
        )
        
        
        // alarmToolBarButtonStack
        addAlarmButton.buttonAction = { [weak self] in
            guard let self else { return }
            listener?.action(.addAlarmButtonClicked)
        }
        configureAlarmButton.buttonAction = { [weak self] in
            guard let self else { return }
            listener?.action(.configureAlarmListButtonClicked)
        }
        
        [addAlarmButton, configureAlarmButton].forEach {
            alarmToolBarButtonStack.addArrangedSubview($0)
        }
        
        
        // alarmToolBarContainerStack
        [alarmToolBarTitleLabel, UIView(), alarmToolBarButtonStack].forEach {
            alarmToolBarContainerStack.addArrangedSubview($0)
        }
        alarmToolBarContainerView.addSubview(alarmToolBarContainerStack)
        
        
        // alarmToolBarContainerView
        resizableContentView.addSubview(alarmToolBarContainerView)
        
        
        // deleteAlarmGroupBarView
        deleteAlarmGroupBarView.isHidden = true
        deleteAlarmGroupBarView.listener = self
        resizableContentView.addSubview(deleteAlarmGroupBarView)
        
        
        // alarmTableView
        alarmListView.isScrollEnabled = false
        setupAlarmTableView()
        
        
        // deleteGroupAlarmConfirmButton
        deleteGroupAlarmConfirmButton.isHidden = true
        deleteGroupAlarmConfirmButton.buttonAction = { [weak self] in
            guard let self else { return }
            listener?.action(.alarmsWillDelete)
        }
        resizableContentView.addSubview(deleteGroupAlarmConfirmButton)
        
        setupResizableContentViewDrag()
    }
    
    
    func setupLayout() {
        
        // hillView
        hillView.snp.makeConstraints { make in
            make.top.equalTo(orbitLottieView).inset(84)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        
        // orbitSpeechBubbleView
        orbitSpeechBubbleSpeech.snp.makeConstraints { make in
            make.bottom.equalTo(orbitLottieView.snp.top)
            make.centerX.equalTo(orbitLottieView)
        }
        
        
        // orbitLottieView
        orbitLottieView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(82)
            make.centerX.equalToSuperview()
            make.width.equalTo(140)
            make.height.equalTo(140)
        }
        
        
        // orbitImageView
        orbitImageView.snp.makeConstraints { make in
            make.edges.equalTo(orbitLottieView)
        }
        
        
        // fortuneLabelStack
        fortuneLabelStack.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(orbitLottieView.snp.bottom)
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
            make.top.equalToSuperview().inset(14).priority(.high)
            make.top.greaterThanOrEqualTo(self.safeAreaLayoutGuide).inset(14)
            make.horizontalEdges.equalToSuperview()
        }
        
        
        // deleteAlarmGroupBarView
        deleteAlarmGroupBarView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14).priority(.high)
            make.top.greaterThanOrEqualTo(self.safeAreaLayoutGuide).inset(14)
            make.horizontalEdges.equalToSuperview()
        }
        
        
        // alarmTableView
        alarmListView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(alarmToolBarContainerView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        
        // deleteGroupAlarmConfirmButton
        deleteGroupAlarmConfirmButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(24)
            make.width.equalTo(135)
            make.centerX.equalToSuperview()
        }
    }
    
    func setupGesture() {
        self.addGestureRecognizer(screenTapGesture)
        screenTapGesture.cancelsTouchesInView = false
        screenTapGesture.addTarget(self, action: #selector(screenIsTapped(_:)))
    }
    @objc
    func screenIsTapped(_ sender: UITapGestureRecognizer) {
        let touchLocation = sender.location(in: self)
        if let alarmOptionBottomListView {
            // 알람 설정 바텀리스트가 열려있는 경우
            let alarmOptionBottomListViewGloablFrame = alarmOptionBottomListView.convert(alarmOptionBottomListView.bounds, to: self)
            let configureAlarmButtonGlobalFrame = configureAlarmButton.convert(configureAlarmButton.bounds, to: self)
            let isInbound = alarmOptionBottomListViewGloablFrame.contains(touchLocation) || configureAlarmButtonGlobalFrame.contains(touchLocation)
            if !isInbound {
                // 해당화면 밖이 눌린경우
                listener?.action(.screenWithoutAlarmConfigureViewTapped)
            }
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
        // MARK: 상단
        case orbitState(OrbitRenderState)
        case fortuneDeliveryTimeText(String)
        case turnOnFortuneNoti(Bool)
        case turnOnFortuneIsDeliveredBubble(Bool)
        // MARK: 알람리스트
        case loadAlarmList(elements: [AlarmCellRO])
        case insertAlarmListCells(updateInfos: [AlarmListCellUpdateInfo])
        case deleteAlarmListCells(ids: [String])
        case updateAlarmListCell(updateInfos: [AlarmListCellUpdateInfo])
        case setAlarmListMode(AlarmListMode)
        
        
        case alarmGroupDeletionButton(isActive: Bool, text: String)
        case setDeleteAllAlarmCheckBox(isOn: Bool)
        case singleAlarmDeletionViewPresentation(isPresent: Bool, presenting: AlarmCellRO?)
        case updateSingleAlarmDeletionItem(AlarmCellRO)
        case presentAlarmOptionListView
        case dismissAlarmOptionListView
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
            
            
        // MARK: 알람 리스트
        case .loadAlarmList(let elements):
            self.alarmCellRenderObjects = elements
            self.alarmListView.reloadData()
            
        case .insertAlarmListCells(let updateInfos):
            guard updateInfos.isEmpty == false else { break }
            alarmListView.beginUpdates()
            var needUpdateIndexPaths: [IndexPath] = []
            for info in updateInfos {
                let index = info.index
                let renderObject = info.renderObject
                alarmCellRenderObjects.insert(renderObject, at: index)
                needUpdateIndexPaths.append(.init(row: index, section: 0))
            }
            alarmListView.insertRows(
                at: needUpdateIndexPaths,
                with: .bottom
            )
            alarmListView.endUpdates()
            
        case .deleteAlarmListCells(let ids):
            guard ids.isEmpty == false else { break }
            var offsets: [Int] = []
            ids.forEach { id in
                if let index = alarmCellRenderObjects.firstIndex(where: { $0.id == id }) {
                    offsets.append(index)
                }
            }
            guard offsets.isEmpty == false else { break }
            alarmListView.beginUpdates()
            alarmCellRenderObjects.remove(atOffsets: .init(offsets))
            let needUpdateIndexPaths = offsets.map({ IndexPath(row: $0, section: 0) })
            alarmListView.deleteRows(
                at: needUpdateIndexPaths,
                with: .automatic
            )
            alarmListView.endUpdates()
            
        case .updateAlarmListCell(let updateInfos):
            updateInfos.forEach { info in
                // #1. 데이터 소스 업데이트
                alarmCellRenderObjects[info.index] = info.renderObject
                
                // #2. 알람Cell UI 업데이트
                let indexPath = IndexPath(row: info.index, section: 0)
                guard let cell = alarmListView.cellForRow(at: indexPath) as? Cell else { return }
                cell.update(renderObject: info.renderObject)
            }
            
        case .setAlarmListMode(let mode):
            switch mode {
            case .idle:
                deleteGroupAlarmConfirmButton.isHidden = true
                dismissDeleteAllAlarmBarView()
            case .deletion:
                deleteGroupAlarmConfirmButton.isHidden = false
                presentDeleteAllAlarmBarView()
            }
        case .alarmGroupDeletionButton(let isActive, let text):
            deleteGroupAlarmConfirmButton.update(state: isActive ? .active : .inactive)
            deleteGroupAlarmConfirmButton.update(title: text)
        case .setDeleteAllAlarmCheckBox(let isOn):
            deleteAlarmGroupBarView.update(isDeleteAllCheckBoxChecked: isOn)
        case .singleAlarmDeletionViewPresentation(let isPresent, let alarmCellRO):
            if isPresent {
                guard let alarmCellRO else { break }
                presentAlarmDeletionView(alarm: alarmCellRO)
            } else {
                dismissAlarmDeletionView()
            }
        case .updateSingleAlarmDeletionItem(let ro):
            alarmDeletionView?.update(.renderObject(ro))
        case .presentAlarmOptionListView:
            configureAlarmButton.update(state: .selected)
            presentAlarmOptionBottomListView()
        case .dismissAlarmOptionListView:
            configureAlarmButton.update(state: .idle)
            dismissAlarmOptionBottomListView()
        }
        return self
    }
}


// MARK: Update orbit
private extension MainPageView {
    func updateOrbitState(_ state: OrbitRenderState) {
        // Orbit animation
        if let animFilePath = state.orbitMotionLottieFilePath {
            orbitLottieView.animation = .filepath(animFilePath)
            orbitLottieView.play()
            orbitLottieView.alpha = 1
            orbitImageView.alpha = 0
        }
        
        
        // Orbit image
        if let image = state.image {
            orbitImageView.image = image
            orbitLottieView.alpha = 0
            orbitImageView.alpha = 1
        }
        
        
        // Bubble text
        if state.bubbleSpeechKorText.isEmpty {
            orbitSpeechBubbleSpeech.alpha = 0
        } else {
            orbitSpeechBubbleSpeech.update(titleText: state.bubbleSpeechKorText)
            orbitSpeechBubbleSpeech.alpha = 1
        }
        
        
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
        static let minVelocityForFullScreen: CGFloat = -500
        static let minVelocityForHalfScreen: CGFloat = 500
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
    }
    
    
    func setupResizableContentViewDrag() {
        resizableContentView.addGestureRecognizer(resizableContentViewDragRecognizer)
        resizableContentViewDragRecognizer.cancelsTouchesInView = false
        resizableContentViewDragRecognizer.addTarget(self, action: #selector(resizeDragOccurred(_:)))
    }
    
    
    @objc
    func resizeDragOccurred(_ recognizer: UIPanGestureRecognizer) {
        let panGestureVelocity = recognizer.velocity(in: self)
        if panGestureVelocity.y < ResizableContentViewConfig.minVelocityForFullScreen {
            // 풀스크린 변환 조건 충족
            if self.resizableContentViewScreenState == .half {
                chagneTofullScreenMode()
            }
            return
        }
    }
    
    func chagneTofullScreenMode() {
        // 풀스크린 변환 제스처 비활성화
        resizableContentViewDragRecognizer.isEnabled = false
        
        // tableView스크롤 가능
        alarmListView.isScrollEnabled = true
        
        self.resizableContentViewScreenState = .full
        resizableContentViewDragRecognizer.isEnabled = false
        UIView.animate(withDuration: ResizableContentViewConfig.transitionDuration) {
            self.resizableContentView.layer.cornerRadius = ResizableContentViewConfig.cornerRadiusWhenFull
            
            // 레이아웃 조정
            self.resizableContentViewTopConstraintWhenHalf?.deactivate()
            self.resizableContentViewTopConstraintWhenFull?.activate()
            

            self.layoutIfNeeded()
        } completion: { _ in
            self.resizableContentViewDragRecognizer.isEnabled = true
        }
    }
    
    func changeToHalfScreenMode() {
        // 풀스크린 변환 제스처 활성화
        resizableContentViewDragRecognizer.isEnabled = true
        
        // tableView스크롤 불가
        alarmListView.isScrollEnabled = false
        
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


// MARK: TableView
extension MainPageView: UITableViewDelegate, UITableViewDataSource {
    typealias Cell = AlarmCell
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        alarmCellRenderObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let alarmCell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier) as? Cell else { fatalError() }
        
        let renderObject = alarmCellRenderObjects[indexPath.row]
        alarmCell.action = { [weak self] action in
            let cellId = renderObject.id
            guard let self else { return }
            switch action {
            case .activityToggleTapped:
                listener?.action(.alarmActivityStateWillChange(alarmId: cellId))
            case .cellIsLongPressed:
                listener?.action(.alarmCellIsLongPressed(alarmId: cellId))
            case .cellIsTapped:
                switch renderObject.mode {
                case .idle:
                    listener?.action(.alarmCellIsTapped(alarmId: cellId))
                case .deletion:
                    listener?.action(.alarmIsCheckedForDeletion(alarmId: cellId))
                }
            }
        }
        return alarmCell.update(renderObject: renderObject, animated: false)
    }
    
    class AlarmDiffableDataSource: UITableViewDiffableDataSource<Int, AlarmCellRO> {
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
    }
    
    func setupAlarmTableView() {
        // alarmTableView
        alarmListView.backgroundColor = .clear
        alarmListView.delegate = self
        alarmListView.dataSource = self
        alarmListView.rowHeight = UITableView.automaticDimension
        alarmListView.estimatedRowHeight = 102
        alarmListView.separatorStyle = .singleLine
        alarmListView.separatorColor = R.Color.gray800
        alarmListView.separatorInset = .init(top:0,left:24,bottom:0,right: 24)
        alarmListView.contentInset = .init(top: 0, left: 0, bottom: 114, right: 0)
        alarmListView.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
        resizableContentView.addSubview(alarmListView)
        
        // iOS 15+ cell Swipe 관련 버그 해결 코드
        alarmListView.isEditing = true
        alarmListView.isEditing = false
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] (action, view, completionHandler) in
            guard let self else { return }
            let renderObject = alarmCellRenderObjects[indexPath.row]
            let cellId = renderObject.id
            listener?.action(.alarmCellWillDelete(alarmId: cellId))
            completionHandler(true)
        }
        deleteAction.backgroundColor = R.Color.gray500
        deleteAction.image = FeatureResourcesAsset.trashFill.image.withTintColor(R.Color.white100)
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        // Swipe to commit
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0, self.resizableContentViewScreenState == .full {
            changeToHalfScreenMode()
        }
    }
}


// MARK: Alarm deleltion
private extension MainPageView {
    func presentAlarmDeletionView(alarm ro: AlarmCellRO) {
        let deletionView = AlarmDeletionView()
            .update(.renderObject(ro))
            .update(.present)
        deletionView.action = { [weak self] action in
            let cellId = ro.id
            guard let self else { return }
            switch action {
            case .backgroundTapped:
                listener?.action(.singleAlarmDeletionViewBackgroundTapped)
            case .deleteButtonClicked:
                listener?.action(.alarmCellWillDelete(alarmId: cellId))
            case .deletionItemToggleIsTapped:
                listener?.action(.alarmActivityStateWillChange(alarmId: cellId))
            }
        }
        self.alarmDeletionView = deletionView
        addSubview(deletionView)
        
        // Layout
        deletionView.layer.zPosition = 200
        deletionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func dismissAlarmDeletionView() {
        guard let deletionView = self.alarmDeletionView else { return }
        deletionView.update(.dismiss(completion: { [weak self] in
            guard let self else { return }
            alarmDeletionView?.removeFromSuperview()
            alarmDeletionView = nil
        }))
    }
}


// MARK: bottom list view
private extension MainPageView {
    func presentAlarmOptionBottomListView() {
        guard alarmOptionBottomListView == nil else { return }
        // List View
        let listView = UIView()
        listView.backgroundColor = R.Color.gray700
        listView.layer.cornerRadius = 15
        listView.layer.borderWidth = 1
        listView.layer.borderColor = R.Color.gray600.cgColor
        resizableContentView.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.top.equalTo(alarmToolBarContainerView.snp.bottom)
            make.right.equalToSuperview().inset(16)
        }
        self.alarmOptionBottomListView = listView
        
        // Sub views
        let editButton = DSRightImageButton()
            .update(titleText: "편집")
            .update(image: FeatureResourcesAsset.edit.image)
        editButton.buttonAction = { [weak self] in
            guard let self else { return }
            configureAlarmButton.update(state: .idle)
            listener?.action(.changeModeToDeletionButtonClicked)
        }
        
        // containerView
        let containerView: UIStackView = .init(arrangedSubviews: [
            editButton
        ])
        containerView.axis = .vertical
        containerView.alignment = .fill
        containerView.spacing = 0
        listView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
        }
    }
    
    func dismissAlarmOptionBottomListView() {
        guard let alarmOptionBottomListView else { return }
        alarmOptionBottomListView.removeFromSuperview()
        self.alarmOptionBottomListView = nil
    }
}


// MARK: DeleteAlarmGroup
extension MainPageView {
    func presentDeleteAllAlarmBarView() {
        alarmToolBarContainerView.alpha = 0
        deleteAlarmGroupBarView.isHidden = false
    }
    
    func dismissDeleteAllAlarmBarView() {
        alarmToolBarContainerView.alpha = 1
        deleteAlarmGroupBarView.isHidden = true
    }
    
    func action(_ action: DeleteAlarmGroupBarView.Action) {
        switch action {
        case .cancelButtonTapped:
            dismissDeleteAllAlarmBarView()
            listener?.action(.changeModeToIdleButtonClicked)
        case .selectAllButtonTapped:
            listener?.action(.deleteAllAlarmCheckBoxTapped)
        }
    }
}


#Preview {
    MainPageView()
}
