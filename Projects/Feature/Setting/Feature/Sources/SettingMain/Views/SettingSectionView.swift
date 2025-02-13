//
//  SettingSectionView.swift
//  Setting
//
//  Created by choijunios on 2/13/25.
//

import UIKit

import FeatureUIDependencies



protocol SettingSectionViewListener: AnyObject {
    func action(_ action: SettingSectionView.Action)
}


final class SettingSectionView: UIStackView {
    // Action
    enum Action {
        case rowIsTapped(id: String)
    }
    
    
    // Listener
    weak var listener: SettingSectionViewListener?
    
    
    // Sub views
    private let titleLabel: UILabel = .init()
    private let itemStack: UIStackView = .init()
    private let contentStack: UIStackView = .init()
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init(coder: NSCoder) { fatalError() }
}


// MARK: Public interface
extension SettingSectionView {
    @discardableResult
    func update(sectionTitleText: String) -> Self {
        titleLabel.displayText = sectionTitleText.displayText(
            font: .body1Regular,
            color: R.Color.gray300
        )
        return self
    }
    
    @discardableResult
    func update(items: [SettingSectionItemRO]) -> Self {
        itemStack.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        for item in items {
            let itemView = DSSharedListItemView()
            itemView.update(titleText: item.title)
            let itemId = item.id
            itemView.tapAction = { [weak self] in
                guard let self else { return }
                listener?.action(.rowIsTapped(id: itemId))
            }
            itemStack.addArrangedSubview(itemView)
        }
        return self
    }
}


// MARK: Setup
private extension SettingSectionView {
    func setupUI() {
        // self
        self.backgroundColor = .clear
        
        
        // titleLabel
        titleLabel.textAlignment = .natural
        
        
        // itemStack
        itemStack.axis = .vertical
        itemStack.spacing = 24
        itemStack.alignment = .fill
        
        
        // contentStack
        contentStack.axis = .vertical
        contentStack.alignment = .fill
        contentStack.spacing = 12
        [titleLabel, itemStack].forEach {
            contentStack.addArrangedSubview($0)
        }
        addSubview(contentStack)
    }
    
    
    func setupLayout() {
        // contentStack
        contentStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
}


#Preview {
    SettingSectionView()
        .update(sectionTitleText: "서비스 약관")
        .update(items: [
            .init(id: "1", title: "이용약관"),
            .init(id: "2", title: "개인정보 처리방침"),
        ])
}
