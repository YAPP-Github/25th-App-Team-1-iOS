//
//  String+Extension.swift
//  FeatureResources
//
//  Created by 손병근 on 1/4/25.
//

import UIKit

public extension String {
    func displayText(font: R.Font) -> NSAttributedString {
        attributedString(font: font)
    }
    
    private func toParagraphStyle(font: R.Font) -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = font.lineSpacing - font.size // 추가 간격 계산
        paragraphStyle.minimumLineHeight = font.lineSpacing
        paragraphStyle.maximumLineHeight = font.lineSpacing
        return paragraphStyle
    }
    
    /// LetterSpacing 포함 NSAttributedString 생성
    private  func attributedString(font: R.Font) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font.toUIFont() ?? UIFont.systemFont(ofSize: font.size),
            .kern: font.letterSpacing, // 글자 간격
            .paragraphStyle: toParagraphStyle(font: font)
        ]
        return NSAttributedString(string: self, attributes: attributes)
    }
}
