//
//  PageIndicatorView.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import UIKit
import FeatureThirdPartyDependencies
import FeatureUIDependencies

final class PageIndicatorView: UIView {
    init(activeCount: Int, totalCount: Int) {
        self.activeCount = activeCount
        self.totalCount = totalCount
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let activeCount: Int
    private let totalCount: Int
    private let stackView = UIStackView()
    private let barViews = [UIView]()
    
    private func generateBarView(with color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = 2.5
        view.layer.masksToBounds = true
        return view
    }
}

private extension PageIndicatorView {
    func setupUI() {
        stackView.do {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.spacing = 4
        }
        for _ in 0..<activeCount {
            let view = generateBarView(with: R.Color.white100)
            stackView.addArrangedSubview(view)
        }
        for _ in activeCount..<totalCount {
            let view = generateBarView(with: R.Color.white20)
            stackView.addArrangedSubview(view)
        }
        addSubview(stackView)
    }
    func layout() {
        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.height.equalTo(5)
        }
    }
}
