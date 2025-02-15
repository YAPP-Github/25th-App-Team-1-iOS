//
//  ScrollStackView.swift
//  FeatureFortune
//
//  Created by ever on 2/15/25.
//

import UIKit

final class ScrollStackView: UIScrollView {
    var containerView = UIView()
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.alignment = .fill
        sv.distribution = .fill
        sv.axis = .vertical
        sv.spacing = 0
        return sv
    }()
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func addArrangedSubview(_ view: UIView){
        self.stackView.addArrangedSubview(view)
    }
    
    private func setupUI(){
        contentInsetAdjustmentBehavior = .never
        
        addSubview(containerView)
        containerView.addSubview(stackView)
        containerView.snp.makeConstraints{
            $0.leading.trailing.top.bottom.width.equalToSuperview()
        }
        stackView.snp.makeConstraints{
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set the contentSize based on the height of the stackView
        let height = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        contentSize = CGSize(width: frame.width, height: height)
        invalidateIntrinsicContentSize()
    }
}
