//
//  String+Extension.swift
//  FeatureResources
//
//  Created by 손병근 on 1/4/25.
//

import UIKit

public extension String {
    func displayText(font: R.Font, color: UIColor? = nil) -> NSAttributedString {
        attributedString(font: font, color: color)
    }
    
    private func toParagraphStyle(lineHeight: CGFloat) -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        return paragraphStyle
    }
    
    /// LetterSpacing 포함 NSAttributedString 생성
    private  func attributedString(font: R.Font, color: UIColor?) -> NSAttributedString {
        let adjustedLetterSpacing = font.size * (font.letterSpacing / 100)
        let adjustedLineHeight = font.size * font.lineHeight
        let uiFont = font.toUIFont() ?? UIFont.systemFont(ofSize: font.size)
        
        let paragraphStyle: NSMutableParagraphStyle = .init()
        paragraphStyle.minimumLineHeight = adjustedLineHeight
        paragraphStyle.maximumLineHeight = adjustedLineHeight
        
        let wordMinHeight = uiFont.ascender + abs(uiFont.descender)
        let baseLineOffset = (adjustedLineHeight-wordMinHeight)/2
        
        var attributes: [NSAttributedString.Key: Any] = [
            .font: uiFont,
            .kern: adjustedLetterSpacing, // 글자 간격
            .paragraphStyle: paragraphStyle,
            .baselineOffset : baseLineOffset,
        ]
        if let color {
            attributes[.foregroundColor] = color
        }
        
        return NSAttributedString(string: self, attributes: attributes)
    }
}
