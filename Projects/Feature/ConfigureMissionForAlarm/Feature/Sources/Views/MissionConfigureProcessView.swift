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
        case missionIsSelected(item: MissionItemRenderObject)
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
        conditionView.update(.changeMissionItem(item: item))
        
        addSubview(conditionView)
        conditionView.snp.makeConstraints { make in
            make.top.equalTo(appBar.snp.bottom)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
}


// MARK: Update
extension MissionConfigureProcessView {
    enum Update {
        case presentMissionList(items: [MissionItemRenderObject])
        case presentMissionConditionSetting(item: MissionItemRenderObject)
    }
    
    func update(_ update: Update) {
        switch update {
        case .presentMissionList(let items):
            appBar.update(titleText: "미션 선택")
            presentMissionItemList(items: items)
        case .presentMissionConditionSetting(let item):
            appBar.update(titleText: item.title)
            presentMissionCondtionSettingView(item: item)
        }
    }
}
