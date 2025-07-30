//
//  MissionSelectionIntroView.swift
//  ConfigureMissionForAlarm
//
//  Created by choijunios on 7/21/25.
//

import UIKit

import FeatureUIDependencies

protocol MissionSelectionIntroViewListener: AnyObject {
    func action(_ action: MissionSelectionIntroView.Action)
}

final class MissionSelectionIntroView: UIView {
    
    // Action
    enum Action {
        case addNewMission
        case missionIsSelected(item: MissionItemRenderObject)
        case missionConditionIsSelected(index: Int)
        case missionChangeButtonTapped
        case missionDeleteButtonTapped
        case exitButtonTapped
        case prevButtonTapped
        case missionPreviewButtonTapped
        case missionConditionConfirmButtonTapped
    }
    
    
    // Listener
    weak var listener: MissionSelectionIntroViewListener?
    
    
    // Layout
    private enum Layout {
        static let contentBaseViewHeight: CGFloat = 446
    }
    
    
    // UI
    private let headTitleLabel: UILabel = .init()
    private let contentsBaseView: UIView = .init()
    private let contentsStackView: UIStackView = .init()
    private let titleLabelStack: UIStackView = .init()
    private let titleLabel: UILabel = .init()
    private let subtitleLabel: UILabel = .init()
    private let addMissionButton: DSDefaultCTAButton = .init(
        style: .init(
            type: .tertiary,
            size: .medium,
            cornerRadius: .large
        )
    )
    
    // Current mission UI
    private let currentMissionContainer: UIView = .init()
    private let missionIconImageView: UIImageView = .init()
    private let missionTitleLabel: UILabel = .init()
    private let missionDeleteButton: UIButton = .init()
    
    // Bottom buttons for mission state
    private let bottomButtonContainer: UIStackView = .init()
    private let missionChangeButton: DSDefaultCTAButton = .init(
        style: .init(
            type: .secondary,
            size: .large
        )
    )
    private let confirmButton: DSDefaultCTAButton = .init(
        style: .init(
            type: .primary,
            size: .large
        )
    )
    
    private var missionConfigureProcessView: MissionConfigureProcessView?
    private var hasExistingMission: Bool = false
    
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
}


// MARK: Setup
private extension MissionSelectionIntroView {
    func setupUI() {
        
        // self
        isOpaque = false
        self.backgroundColor = R.Color.gray800
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.borderColor = R.Color.gray700.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 14
        self.layer.masksToBounds = true
        
        
        // titleLabel
        headTitleLabel.displayText = "미션".displayText(font: .heading2SemiBold, color: R.Color.white100)
        addSubview(headTitleLabel)
        
        
        // contentView
        addSubview(contentsBaseView)
        
        
        // contentsStackView
        contentsStackView.alignment = .center
        contentsStackView.axis = .vertical
        contentsStackView.spacing = 32
        contentsBaseView.addSubview(contentsStackView)
        
        
        // titleLabelStack
        titleLabelStack.axis = .vertical
        titleLabelStack.alignment = .center
        titleLabelStack.spacing = 6
        contentsStackView.addArrangedSubview(titleLabelStack)
        
        
        // titleLabels
        titleLabel.displayText = "등록된 미션이 없어요".displayText(font: .body1Bold, color: R.Color.white100)
        titleLabelStack.addArrangedSubview(titleLabel)
        subtitleLabel.displayText = "새 미션을 추가해보세요".displayText(font: .label2regular, color: R.Color.white80)
        titleLabelStack.addArrangedSubview(subtitleLabel)
        
        
        // addMissionButton
        addMissionButton.update(leftImage: FeatureResourcesAsset.plus.image)
        addMissionButton.update(title: "미션추가")
        contentsStackView.addArrangedSubview(addMissionButton)
        addMissionButton.buttonAction = { [unowned self] in
            listener?.action(.addNewMission)
        }
        
        // currentMissionContainer
        currentMissionContainer.do {
            $0.backgroundColor = R.Color.gray700
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
            $0.isHidden = true // 초기에는 숨김
        }
        addSubview(currentMissionContainer)
        
        // missionIconImageView
        missionIconImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
            $0.backgroundColor = R.Color.main100
        }
        currentMissionContainer.addSubview(missionIconImageView)
        
        // missionTitleLabel
        missionTitleLabel.do {
            $0.displayText = "흐들기 15회".displayText(font: .body1SemiBold, color: R.Color.white100)
        }
        currentMissionContainer.addSubview(missionTitleLabel)
        
        // missionDeleteButton
        missionDeleteButton.do {
            $0.setImage(FeatureResourcesAsset.trashFill.image.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = R.Color.gray400
            $0.addTarget(self, action: #selector(missionDeleteButtonTapped), for: .touchUpInside)
        }
        currentMissionContainer.addSubview(missionDeleteButton)
        
        // bottomButtonContainer
        bottomButtonContainer.do {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.isHidden = true // 초기에는 숨김
        }
        addSubview(bottomButtonContainer)
        
        // missionChangeButton
        missionChangeButton.do {
            $0.update(title: "미션변경")
            $0.buttonAction = { [unowned self] in
                listener?.action(.missionChangeButtonTapped)
            }
        }
        bottomButtonContainer.addArrangedSubview(missionChangeButton)
        
        // confirmButton
        confirmButton.do {
            $0.update(title: "완료")
            $0.buttonAction = { [unowned self] in
                listener?.action(.missionConditionConfirmButtonTapped)
            }
        }
        bottomButtonContainer.addArrangedSubview(confirmButton)
    }
    
    func setupLayout() {
        
        // titleLabel
        headTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(26)
            make.left.equalToSuperview().inset(24)
        }
        
        
        // contentsBaseView
        contentsBaseView.snp.makeConstraints { make in
            make.top.equalTo(headTitleLabel).offset(32)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(Layout.contentBaseViewHeight)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(36)
        }
        
        
        // contentsStackView
        contentsStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        
        // addMissionButton
        addMissionButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(127)
        }
        
        // currentMissionContainer
        currentMissionContainer.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(headTitleLabel.snp.bottom).offset(32)
            make.height.equalTo(54)
        }
        
        // missionIconImageView
        missionIconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        // missionTitleLabel
        missionTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(missionIconImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        
        // missionDeleteButton
        missionDeleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        // bottomButtonContainer
        bottomButtonContainer.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(12)
        }
        
        // missionChangeButton
        missionChangeButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.35)
        }
    }
    
    
    func presentMissionConfigureProcessView() {
        guard missionConfigureProcessView == nil else { return }
        
        let subView = MissionConfigureProcessView()
        subView.listener = self
        addSubview(subView)
        
        subView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.missionConfigureProcessView = subView
    }
    
    func dismissMissionConfigureProcessView() {
        guard let view = missionConfigureProcessView else { return }
        
        view.removeFromSuperview()
        self.missionConfigureProcessView = nil
    }
    
    @objc private func missionDeleteButtonTapped() {
        listener?.action(.missionDeleteButtonTapped)
    }
    
    private func showCurrentMissionUI() {
        hasExistingMission = true
        currentMissionContainer.isHidden = false
        contentsBaseView.isHidden = true
        bottomButtonContainer.isHidden = false
    }
    
    private func showDefaultUI() {
        hasExistingMission = false
        currentMissionContainer.isHidden = true
        contentsBaseView.isHidden = false
        bottomButtonContainer.isHidden = true
    }
    
    private func updateMissionDisplay(item: MissionItemRenderObject, conditionIndex: Int) {
        missionIconImageView.image = item.iconImage
        let conditionItem = item.conditionItems[conditionIndex]
        let titleText = "\(item.title) \(conditionItem.title)"
        missionTitleLabel.displayText = titleText.displayText(font: .body1SemiBold, color: R.Color.white100)
    }
}


// MARK: Request
extension MissionSelectionIntroView {
    enum UpdateRequest {
        case presentMissionList(items: [MissionItemRenderObject])
        case presentMissionConditionSetting(item: MissionItemRenderObject)
        case dismissMissionList
        case dismissMissionConditionSetting
        case selectMissionCondition(index: Int)
        case updateMissionDisplay(item: MissionItemRenderObject, conditionIndex: Int)
        case showDefaultUIAfterMissionDelete
    }
    
    func update(_ request: UpdateRequest) {
        switch request {
        case .presentMissionList(let items):
            presentMissionConfigureProcessView()
            missionConfigureProcessView?.update(.presentMissionList(items: items))
        case .presentMissionConditionSetting(let item):
            // 미션이 있는 경우 현재 미션 컴테이너를 보이고, 기본 UI를 숨김
            showCurrentMissionUI()
            missionConfigureProcessView?.update(.presentMissionConditionSetting(item: item))
        case .selectMissionCondition(let index):
            missionConfigureProcessView?.update(.selectMissionCondition(index: index))
        case .dismissMissionList:
            dismissMissionConfigureProcessView()
        case .dismissMissionConditionSetting:
            missionConfigureProcessView?.update(.dismissMissionConditionSetting)
        case .updateMissionDisplay(let item, let conditionIndex):
            updateMissionDisplay(item: item, conditionIndex: conditionIndex)
        case .showDefaultUIAfterMissionDelete:
            showDefaultUI()
        }
    }
}


// MARK: Listener
extension MissionSelectionIntroView: MissionConfigureProcessViewViewListener {
    func action(_ action: MissionConfigureProcessView.Action) {
        switch action {
        case .missionIsSelected(let item):
            listener?.action(.missionIsSelected(item: item))
        case .missionConditionIsSelected(let index):
            listener?.action(.missionConditionIsSelected(index: index))
        case .prevButtonTapped:
            listener?.action(.prevButtonTapped)
        case .exitButtonTapped:
            listener?.action(.exitButtonTapped)
        case .missionConditionConfirmButtonTapped:
            listener?.action(.missionConditionConfirmButtonTapped)
        case .missionPreviewButtonTapped:
            listener?.action(.missionPreviewButtonTapped)
        }
    }
}
