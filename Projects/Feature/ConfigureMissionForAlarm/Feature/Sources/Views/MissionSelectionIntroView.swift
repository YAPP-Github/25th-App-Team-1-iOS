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
        case exitButtonTapped
        case prevButtonTapped
        case missionPreviewButtonTapped
        case missionConditionConfirmButtonTapped
    }
    
    
    // Listener
    weak var listener: MissionSelectionIntroViewListener?
    
    
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
    private var missionConfigureProcessView: MissionConfigureProcessView?
    
    
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
            make.horizontalEdges.equalToSuperview().inset(24)
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
}


// MARK: Request
extension MissionSelectionIntroView {
    enum UpdateRequest {
        case presentMissionList(items: [MissionItemRenderObject])
        case presentMissionConditionSetting(item: MissionItemRenderObject)
        case dismissMissionList
        case dismissMissionConditionSetting
        case selectMissionCondition(index: Int)
    }
    
    func update(_ request: UpdateRequest) {
        switch request {
        case .presentMissionList(let items):
            presentMissionConfigureProcessView()
            missionConfigureProcessView?.update(.presentMissionList(items: items))
        case .presentMissionConditionSetting(let item):
            missionConfigureProcessView?.update(.presentMissionConditionSetting(item: item))
        case .selectMissionCondition(let index):
            missionConfigureProcessView?.update(.selectMissionCondition(index: index))
        case .dismissMissionList:
            dismissMissionConfigureProcessView()
        case .dismissMissionConditionSetting:
            missionConfigureProcessView?.update(.dismissMissionConditionSetting)
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
