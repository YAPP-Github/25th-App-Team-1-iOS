//
//  UserInfoCardView.swift
//  Setting
//
//  Created by choijunios on 2/13/25.
//

import UIKit

import FeatureUIDependencies
import FeatureCommonDependencies

final class UserInfoCardView: TouchDetectingView {
    // Sub views
    private let nameLabel: UILabel = .init()
    private let genderLabel: UILabel = .init()
    private let firstRowStack: UIStackView = .init()
    
    private let lunarLabel: UILabel = .init()
    private let birthDateLabel: UILabel = .init()
    private let bornTimeLabel: UILabel = .init()
    private let secondRowStack: UIStackView = .init()
    
    private let labelCotainerStack: UIStackView = .init()
    
    private let rightCursorImage: UIImageView = .init()
    private let containerStack: UIStackView = .init()
    
    
    // Tap action
    var tapAction: (() -> Void)?
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    
    override func onTouchOut() {
        tapAction?()
    }
}


// MARK: Public interface
extension UserInfoCardView {
    func update(renderObject ro: UserInfoCardRO) {
        // 이름
        nameLabel.displayText = ro.nameText.displayText(
            font: .headline1SemiBold,
            color: R.Color.white100
        )
        
        // 성별
        genderLabel.displayText = ro.genderText.displayText(
            font: .headline1SemiBold,
            color: R.Color.white100
        )
        
        // 음력/양력
        lunarLabel.displayText = ro.lunarText.displayText(
            font: .body1Regular,
            color: R.Color.gray50
        )
        
        // 생년월일
        birthDateLabel.displayText = ro.birthDateText.displayText(
            font: .body1Regular,
            color: R.Color.gray50
        )
        
        // 생년월일
        if let bornTimeText = ro.bornTimeText {
            bornTimeLabel.isHidden = false
            bornTimeLabel.displayText = bornTimeText.displayText(
                font: .body1Regular,
                color: R.Color.gray50
            )
        } else {
            bornTimeLabel.isHidden = true
        }
    }
}


// MARK: Setup
private extension UserInfoCardView {
    func setupUI() {
        // self
        self.backgroundColor = R.Color.gray700
        self.layer.cornerRadius = 20
        
        
        // firstRowStack
        firstRowStack.axis = .horizontal
        firstRowStack.spacing = 4
        firstRowStack.alignment = .center
        [
            nameLabel,
            DotView(diameter: 3, color: R.Color.gray300),
            genderLabel
        ].forEach {
            firstRowStack.addArrangedSubview($0)
        }
        
        
        // secondRowStack
        secondRowStack.axis = .horizontal
        secondRowStack.spacing = 4
        secondRowStack.alignment = .center
        [lunarLabel, birthDateLabel, bornTimeLabel].forEach {
            secondRowStack.addArrangedSubview($0)
        }
        
        
        // labelCotainerStack
        labelCotainerStack.axis = .vertical
        labelCotainerStack.spacing = 4
        labelCotainerStack.alignment = .leading
        [firstRowStack, secondRowStack].forEach {
            labelCotainerStack.addArrangedSubview($0)
        }
        
        
        // rightCursorImage
        rightCursorImage.contentMode = .scaleAspectFit
        rightCursorImage.image = FeatureResourcesAsset.chevronRight.image
        rightCursorImage.tintColor = R.Color.gray300
        
        
        // containerStack
        containerStack.axis = .horizontal
        containerStack.spacing = 4
        containerStack.alignment = .center
        [labelCotainerStack, UIView(), rightCursorImage].forEach {
            containerStack.addArrangedSubview($0)
        }
        addSubview(containerStack)
    }
    
    
    func setupLayout() {
        // rightCursorImage
        rightCursorImage.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        
        
        // containerStack
        containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(24)
        }
    }
}


#Preview {
    let view = UserInfoCardView()
    view
        .update(
            renderObject: .init(
                nameText: "최준영",
                genderText: "남성",
                lunarText: "양력",
                birthDateText: "2022년 3월 8일",
                bornTimeText: "22시 30분"
            )
        )
    return view
}
