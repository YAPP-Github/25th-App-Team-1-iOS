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


final class MainPageView: UIView, UITableViewDelegate, DeleteAlarmGroupBarViewListener {
    
    // Action
    enum Action {
        case fortuneNotiButtonClicked
        case applicationSettingButtonClicked
        case addAlarmButtonClicked
        
        case alarmSelected(alarmId: String)
        case alarmActivityStateWillChange(alarmId: String)
        case alarmIsChecked(alarmId: String)
        case alarmWillDelete(alarmId: String)
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
    private let configAlarmButton: DSSelectableIconButton = .init(
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
    
    // - TableView
    private let alarmTableView: UITableView = .init()
    private var alarmTableDiffableDataSource: UITableViewDiffableDataSource<Int, AlarmCellRO>!
    
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
        orbitView.loopMode = .loop
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
        addAlarmButton.buttonAction = { [weak self] in
            guard let self else { return }
            self.listener?.action(.addAlarmButtonClicked)
        }
        configAlarmButton.buttonAction = { [weak self] state in
            guard let self else { return }
            switch state {
            case .idle:
                dismissAlarmOptionBottomListView()
                break
            case .selected:
                presentAlarmOptionBottomListView()
                break
            case .pressed:
                return
            }
        }
        
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
        
        
        // deleteAlarmGroupBarView
        deleteAlarmGroupBarView.isHidden = true
        deleteAlarmGroupBarView.listener = self
        resizableContentView.addSubview(deleteAlarmGroupBarView)
        
        
        // alarmTableView
        alarmTableView.isScrollEnabled = false
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
        alarmTableView.snp.makeConstraints { make in
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
        case presentAlarmGroupDeletionView
        case dismissAlarmGroupDeletionView
        case alarmGroupDeletionButton(isActive: Bool, text: String)
        case setDeleteAllAlarmCheckBox(isOn: Bool)
        case singleAlarmDeletionViewPresentation(isPresent: Bool, presenting: AlarmCellRO?)
        case updateSingleAlarmDeletionItem(AlarmCellRO)
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
        case .presentAlarmGroupDeletionView:
            deleteGroupAlarmConfirmButton.isHidden = false
            presentDeleteAllAlarmBarView()
        case .dismissAlarmGroupDeletionView:
            deleteGroupAlarmConfirmButton.isHidden = true
            dismissDeleteAllAlarmBarView()
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
        alarmTableView.isScrollEnabled = true
        
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
        alarmTableView.isScrollEnabled = false
        
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
extension MainPageView {
    typealias Cell = AlarmCell
    
    class AlarmDiffableDataSource: UITableViewDiffableDataSource<Int, AlarmCellRO> {
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
    }
    
    func presentAlarmROs(_ ros: [AlarmCellRO]) {
        var snapShot = NSDiffableDataSourceSnapshot<Int, AlarmCellRO>()
        snapShot.appendSections([0])
        snapShot.appendItems(ros)
        self.alarmTableDiffableDataSource.apply(snapShot, animatingDifferences: false)
    }
    
    func setupAlarmTableView() {
        // alarmTableDiffableDataSource
        let diffableDataSource = AlarmDiffableDataSource(
            tableView: alarmTableView) { [weak self] tableView, indexPath, ro in
                guard let self, let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier) as? Cell else { fatalError() }
                cell.action = { [weak self] action in
                    let cellId = ro.id
                    guard let self else { return }
                    switch action {
                    case .activityToggleTapped:
                        listener?.action(.alarmActivityStateWillChange(alarmId: cellId))
                    case .cellIsLongPressed:
                        listener?.action(.alarmCellIsLongPressed(alarmId: cellId))
                    case .cellIsTapped:
                        switch ro.mode {
                        case .idle:
                            listener?.action(.alarmSelected(alarmId: cellId))
                        case .deletion:
                            listener?.action(.alarmIsChecked(alarmId: cellId))
                        }
                    }
                }
                return cell.update(renderObject: ro)
            }
        self.alarmTableDiffableDataSource = diffableDataSource
        
        // alarmTableView
        alarmTableView.backgroundColor = .clear
        alarmTableView.delegate = self
        alarmTableView.dataSource = diffableDataSource
        alarmTableView.rowHeight = UITableView.automaticDimension
        alarmTableView.estimatedRowHeight = 102
        alarmTableView.separatorStyle = .singleLine
        alarmTableView.separatorColor = R.Color.gray800
        alarmTableView.separatorInset = .init(top:0,left:24,bottom:0,right: 24)
        alarmTableView.contentInset = .init(top: 0, left: 0, bottom: 114, right: 0)
        alarmTableView.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
        resizableContentView.addSubview(alarmTableView)
        
        // iOS 15+ cell Swipe 관련 버그 해결 코드
        alarmTableView.isEditing = true
        alarmTableView.isEditing = false
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] (action, view, completionHandler) in
            guard let self else { return }
            let renderObject = alarmTableDiffableDataSource.snapshot().itemIdentifiers[indexPath.item]
            let cellId = renderObject.id
            listener?.action(.alarmWillDelete(alarmId: cellId))
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
                listener?.action(.alarmWillDelete(alarmId: cellId))
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
            configAlarmButton.update(state: .idle)
            dismissAlarmOptionBottomListView()
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
