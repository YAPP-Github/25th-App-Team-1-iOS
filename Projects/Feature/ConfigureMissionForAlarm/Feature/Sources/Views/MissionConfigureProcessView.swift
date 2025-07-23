//
//  MissionConfigureProcessView.swift
//  ConfigureMissionForAlarm
//
//  Created by choijunios on 7/22/25.
//

import UIKit

import FeatureResources
import FeatureUIDependencies

protocol MissionConfigureProcessViewViewListener: AnyObject {
    func action(_ action: MissionConfigureProcessView.Action)
}

final class MissionConfigureProcessView: UIView {
    
    // Action
    enum Action {
        case exitButtonTapped
        case prevButtonTapped
        case missionPreviewButtonTapped
        case missionConditionConfirmButtonTapped
        case missionIsSelected(item: MissionItemRenderObject)
        case missionConditionIsSelected(index: Int)
    }
    
    
    // Listener
    weak var listener: MissionConfigureProcessViewViewListener?
    
    
    // UI
    private let prevButton: DSDefaultIconButton = .init(
        style: .init(
            type: .default,
            image: FeatureResourcesAsset.chevronLeft.image,
            size: .medium
        )
    )
    private let exitButton: DSDefaultIconButton = .init(
        style: .init(
            type: .default,
            image: FeatureResourcesAsset.xmark.image,
            size: .small
        )
    )
    private let appBar: DSAppBar = .init()
    private let contentView: UIView = .init()
    private var conditionSettingView: MissionConditionSettingView?
    
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
}


// MARK: Setup
private extension MissionConfigureProcessView {
    func setupUI() {
        
        // self
        self.backgroundColor = R.Color.gray800
        
        
        // appBar
        appBar.update(titleText: "Test")
        appBar.insertLeftView(prevButton)
        appBar.insertRightView(exitButton)
        addSubview(appBar)
        
        
        // prevButton
        prevButton.buttonAction = { [unowned self] in
            listener?.action(.prevButtonTapped)
        }
        
        
        // exitButton
        exitButton.buttonAction = { [unowned self] in
            listener?.action(.exitButtonTapped)
        }
        
        
        // contentView
        addSubview(contentView)
    }
    
    
    func setupLayout() {
        
        // appBar
        appBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        
        // contentView
        contentView.snp.makeConstraints { make in
            make.top.equalTo(appBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    
    func presentMissionItemList(items: [MissionItemRenderObject]) {
        
        let subViews = items.map { item in
            let itemView = MissionItemView()
            itemView.update(.image(item.iconImage))
            itemView.update(.title(item.title))
            itemView.action = { [unowned self] action in
                switch action {
                case .itemIsTapped:
                    listener?.action(.missionIsSelected(item: item))
                }
            }
            return itemView
        }
        
        let stackView = UIStackView(arrangedSubviews: subViews)
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        
        let scrollView = UIScrollView()
        scrollView.addSubview(stackView)
        
        let frameGuide = scrollView.safeAreaLayoutGuide
        let contentGuide = scrollView.contentLayoutGuide
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(contentGuide)
            make.horizontalEdges.equalTo(frameGuide)
        }
        
        contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    
    func presentMissionCondtionSettingView(item: MissionItemRenderObject) {
        
        let conditionView = MissionConditionSettingView()
        conditionView.listener = self
        conditionView.update(.changeMissionItem(item: item))
        self.conditionSettingView = conditionView
        
        addSubview(conditionView)
        conditionView.snp.makeConstraints { make in
            make.top.equalTo(appBar.snp.bottom)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    
    func dismissMissionCondtionSettingView() {
        guard let view = conditionSettingView else { return }
        view.removeFromSuperview()
        self.conditionSettingView = nil
    }
}


// MARK: Update
extension MissionConfigureProcessView {
    enum Update {
        case presentMissionList(items: [MissionItemRenderObject])
        case presentMissionConditionSetting(item: MissionItemRenderObject)
        case selectMissionCondition(index: Int)
        case dismissMissionConditionSetting
    }
    
    func update(_ update: Update) {
        switch update {
        case .presentMissionList(let items):
            appBar.update(titleText: "미션 선택")
            presentMissionItemList(items: items)
        case .presentMissionConditionSetting(let item):
            appBar.update(titleText: item.title)
            presentMissionCondtionSettingView(item: item)
        case .selectMissionCondition(let index):
            conditionSettingView?.update(.selectCondition(index: index))
        case .dismissMissionConditionSetting:
            appBar.update(titleText: "미션 선택")
            dismissMissionCondtionSettingView()
        }
    }
}


extension MissionConfigureProcessView: MissionConditionSettingViewListener {
    func action(_ action: MissionConditionSettingView.Action) {
        switch action {
        case .buttonIsTapped(let index):
            listener?.action(.missionConditionIsSelected(index: index))
        case .confirmButtonIsTapped:
            listener?.action(.missionConditionConfirmButtonTapped)
        case .previewButtonIsTapped:
            listener?.action(.missionPreviewButtonTapped)
        }
    }
}
