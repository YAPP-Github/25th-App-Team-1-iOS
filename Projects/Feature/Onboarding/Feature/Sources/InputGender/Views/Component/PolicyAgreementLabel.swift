//
//  PolicyAgreementLabel.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/7/25.
//

import UIKit

import FeatureResources

final class PolicyAgreementLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        
        setupText()
    }
    required init?(coder: NSCoder) { nil }
    
    private func setupText() {
        
        let baseText = "서비스 시작 시 이용약관 및 개인정보처리방침에 동의하게 됩니다."
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: FeatureResourcesFontFamily.Pretendard.regular.font(size: 12),
            .foregroundColor: R.Color.gray500,
            .kern: -0.12,
            .paragraphStyle: {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                return paragraphStyle
            }()
        ]
        
        let attributedString: NSMutableAttributedString = .init(
            string: baseText, attributes: attributes)
        
        
        let underlineAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
        
        // Apply underline to "이용약관"
        if let termsRange = baseText.range(of: "이용약관") {
            let nsRange = NSRange(termsRange, in: baseText)
            attributedString.addAttributes(underlineAttributes, range: nsRange)
        }
        
        // Apply underline to "개인정보처리방침"
        if let privacyRange = baseText.range(of: "개인정보처리방침") {
            let nsRange = NSRange(privacyRange, in: baseText)
            attributedString.addAttributes(underlineAttributes, range: nsRange)
        }
        
        self.attributedText = attributedString
    }
}

#Preview {
    
    PolicyAgreementLabel()
}
