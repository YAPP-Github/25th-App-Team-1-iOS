//
//  SettingMainView.swift
//  Setting
//
//  Created by choijunios on 2/13/25.
//

import UIKit

import FeatureUIDependencies
import FeatureCommonDependencies

protocol SettingMainViewListener: AnyObject {
    func action(_ action: SettingMainView.Action)
}

final class SettingMainView: UIView, SettingSectionViewListener, OpinionViewListener {
    // Action
    enum Action {
        case settingItemIsTapped(sectionId: Int, rowId: Int)
        case opinionButtonTapped
        case userInfoCardTapped
        case backButtonTapped
    }
    
    
    // Listener
    weak var listener: SettingMainViewListener?
    
    
    // Sub views
    private let navigationBar: DSAppBar = .init()
    private let backButton: DSDefaultIconButton = .init(
        style: .init(
            type: .default,
            image: FeatureResourcesAsset.gnbLeft.image,
            size: .medium
        )
    )
    private let userInfoCard: UserInfoCardView = .init()
    private let opinionView: OpinionView = .init()
    
    private let scrollView: UIScrollView = .init()
    private let contentStack: UIStackView = .init()
    
    private let appVersionLabel: UILabel = .init()
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
}


extension SettingMainView {
    enum Update {
        case sections(sections: [SettingSectionRO])
        case userInfoCard(userInfo: UserInfoCardRO)
        case versionText(text: String)
    }
    
    func update(_ update: Update) {
        switch update {
        case .sections(let sections):
            sections.forEach { ro in
                let sectionView = SettingSectionView()
                    .update(sectionTitleText: ro.titleText)
                    .update(sectionId: ro.id, items: ro.items)
                sectionView.listener = self
                contentStack.addArrangedSubview(sectionView)
            }
        case .userInfoCard(let userInfo):
            userInfoCard.update(renderObject: userInfo)
        case .versionText(let text):
            appVersionLabel.displayText = text.displayText(
                font: .body1Regular,
                color: R.Color.gray300
            )
        }
    }
}


// MARK: Setup
private extension SettingMainView {
    func setupUI() {
        // self
        self.backgroundColor = R.Color.gray900
        
        
        // [navigationBar] backButton
        backButton.buttonAction = { [weak self] in
            guard let self else { return }
            listener?.action(.backButtonTapped)
        }
        
        
        // opinionView
        opinionView.listener = self
        
        
        // userInfoCard
        userInfoCard.tapAction = { [weak self] in
            guard let self else { return }
            listener?.action(.userInfoCardTapped)
        }
        
        
        // navigationBar
        navigationBar
            .update(titleText: "설정")
            .insertLeftView(backButton)
        addSubview(navigationBar)
        
        
        // contentStack
        contentStack.axis = .vertical
        contentStack.alignment = .fill
        contentStack.spacing = 24
        let userInfoCardStackForPadding = UIStackView(arrangedSubviews: [
            SpacerView(width: 20),userInfoCard,SpacerView(width: 20)
        ])
        userInfoCardStackForPadding.axis = .horizontal
        userInfoCardStackForPadding.alignment = .center
        [userInfoCardStackForPadding, opinionView].forEach {
            contentStack.addArrangedSubview($0)
        }
        scrollView.addSubview(contentStack)
        
        
        // scrollView
        addSubview(scrollView)
        
        
        // appVersionLabel
        addSubview(appVersionLabel)
    }
    
    func setupLayout() {
        // navigationBar
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        
        // contentStack
        let svContentLayoutGuide = scrollView.contentLayoutGuide
        let svFrameLayoutGuide = scrollView.frameLayoutGuide
        contentStack.snp.makeConstraints { make in
            make.top.equalTo(svContentLayoutGuide).inset(12)
            make.horizontalEdges.equalTo(svContentLayoutGuide)
            make.width.equalTo(svFrameLayoutGuide)
        }
        
        
        // scrollView
        scrollView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(navigationBar.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        
        // appVersionLabel
        appVersionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(24)
        }
    }
}


// MARK: SettingSectionViewListener
extension SettingMainView {
    func action(_ action: SettingSectionView.Action) {
        switch action {
        case .rowIsTapped(let sectionId, let rowId):
            listener?.action(.settingItemIsTapped(sectionId: sectionId, rowId: rowId))
        }
    }
}


// MARK: OpinionViewListener
extension SettingMainView {
    func action(_ action: OpinionView.Action) {
        switch action {
        case .sendOpinionButtonClicked:
            listener?.action(.opinionButtonTapped)
        }
    }
}
