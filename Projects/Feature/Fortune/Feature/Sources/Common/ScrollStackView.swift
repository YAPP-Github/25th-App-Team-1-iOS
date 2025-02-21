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
    
    var swipeLeft: (() -> Void)?
    var swipeRight: (() -> Void)?
    var tapped: (() -> Void)?
    
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
        
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        rightGesture.direction = .right
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        leftGesture.direction = .left
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(rightGesture)
        addGestureRecognizer(leftGesture)
        addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set the contentSize based on the height of the stackView
        let height = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        contentSize = CGSize(width: frame.width, height: height)
        invalidateIntrinsicContentSize()
    }
    
    @objc
    private func swiped(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .up:
            print("up")
        case .down:
            print("down")
        case .left:
            swipeLeft?()
        case .right:
            swipeRight?()
        default:
            break
        }
    }
    
    @objc
    private func viewTapped() {
        tapped?()
    }
}
