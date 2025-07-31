//
//  MissionListPage.swift
//  ConfigureMissionForAlarm
//
//  Created by choijunios on 7/30/25.
//

import UIKit

import FeatureResources
import FeatureUIDependencies

final class MissionListPage: UIView {
    
    // Action
    enum Action {
        case exitButtonTapped
        case prevButtonTapped
        case missionIsSelected(item: MissionItemRenderObject)
    }
    var pageAction: ((Action) -> ())?
    
    
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
    private var listContentsView: UIView?
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
}


private extension MissionListPage {
    func setupUI() {
        
        // self
        self.backgroundColor = R.Color.gray800
        
        
        // appBar
        appBar.insertLeftView(prevButton)
        appBar.insertRightView(exitButton)
        addSubview(appBar)
        
        
        // prevButton
        prevButton.buttonAction = { [unowned self] in
            pageAction?(.prevButtonTapped)
        }
        
        
        // exitButton
        exitButton.buttonAction = { [unowned self] in
            pageAction?(.exitButtonTapped)
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
}


extension MissionListPage {
    func update(missionItems: [MissionItemRenderObject]) {
        
        if let listContentsView {
            listContentsView.removeFromSuperview()
            self.listContentsView = nil
        }
        
        let subViews = missionItems.map { item in
            let itemView = MissionItemView()
            itemView.update(.image(item.iconImage))
            itemView.update(.title(item.title))
            itemView.action = { [unowned self] action in
                switch action {
                case .itemIsTapped:
                    pageAction?(.missionIsSelected(item: item))
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
        self.listContentsView = scrollView
    }
}


#Preview(traits: .defaultLayout, body: {
    let page = MissionListPage()
    page.update(missionItems: [.shake, .tap])
    return page
})
