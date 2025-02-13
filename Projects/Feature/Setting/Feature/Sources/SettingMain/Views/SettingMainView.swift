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
        case settingItemIsTapped(rowId: String)
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
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
}


extension SettingMainView {
    enum Update {
        case setSection(sections: [SettingSectionRO])
    }
    
    func update(_ update: Update) {
        switch update {
        case .setSection(let sections):
            sections.forEach { ro in
                let sectionView = SettingSectionView()
                    .update(sectionTitleText: ro.titleText)
                    .update(items: ro.items)
                sectionView.listener = self
                contentStack.addArrangedSubview(sectionView)
            }
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
    }
}


// MARK: SettingSectionViewListener
extension SettingMainView {
    func action(_ action: SettingSectionView.Action) {
        switch action {
        case .rowIsTapped(let id):
            listener?.action(.settingItemIsTapped(rowId: id))
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


#Preview {
    let view = SettingMainView()
    view.update(.setSection(sections: [
        SettingSectionRO(order: 0, titleText: "테스트", items: [
            .init(id: "0", title: "개인정보 처리방침"),
            .init(id: "1", title: "개인정보 처리방침"),
            .init(id: "2", title: "개인정보 처리방침"),
        ])
    ]))
    return view
}
