//
//  InputNameHelper.swift
//  FeatureOnboarding
//
//  Created by ever on 1/11/25.
//

import Foundation

struct InputNameHelper {
    enum InputType {
        case korean
        case english
        case mixed
    }
    
    private let allPattern = "^[A-Za-zㄱ-ㅎ가-힣]+$"
    private let koreanOnlyPattern = "^[ㄱ-ㅎ가-힣]{1,6}$"
    private let englishOnlyPattern = "^[A-Za-z]{1,12}$"
    
    private let allRegex: NSRegularExpression
    private let koreanOnlyRegex: NSRegularExpression
    private let englishOnlyRegex: NSRegularExpression
    
    init?() {
        do {
            allRegex = try NSRegularExpression(pattern: allPattern)
            koreanOnlyRegex = try NSRegularExpression(pattern: koreanOnlyPattern)
            englishOnlyRegex = try NSRegularExpression(pattern: englishOnlyPattern)
        } catch {
            print("정규식 초기화 오류: \(error)")
            return nil
        }
    }
    
    private func isValidInput(_ input: String) -> Bool {
        let range = NSRange(location: 0, length: input.utf16.count)
        return allRegex.firstMatch(in: input, options: [], range: range) != nil
    }
    
    // 입력 유형 확인
    private func getInputType(_ input: String) -> InputType? {
        let range = NSRange(location: 0, length: input.utf16.count)
        
        if koreanOnlyRegex.firstMatch(in: input, options: [], range: range) != nil {
            return .korean
        }
        
        if englishOnlyRegex.firstMatch(in: input, options: [], range: range) != nil {
            return .english
        }
        
        if allRegex.firstMatch(in: input, options: [], range: range) != nil {
            return .mixed
        }
        
        return nil // 유효하지 않은 입력
    }
    
    // 가중치 기반 길이 검사
    func isWithinMaxLength(_ input: String) -> Bool {
        guard isValidInput(input) else { return false }
        
        guard let type = getInputType(input) else { return false }
        
        switch type {
        case .korean:
            return input.count <= 6
        case .english:
            return input.count <= 13
        case .mixed:
            // 한글은 1, 영어는 0.5로 계산
            var totalWeight: Double = 0.0
            for character in input {
                if isKorean(character) {
                    totalWeight += 1.0
                } else if isEnglish(character) {
                    totalWeight += 0.5
                }
            }
            return totalWeight <= 6.0
        }
    }
    
    // 한글 문자 여부 확인
    private func isKorean(_ character: Character) -> Bool {
        return ("가"..."힣").contains(character) ||
        ("ㄱ"..."ㅎ").contains(character) ||
        ("ㅏ"..."ㅣ").contains(character)
    }
    
    // 영어 문자 여부 확인
    private func isEnglish(_ character: Character) -> Bool {
        return ("A"..."Z").contains(character) || ("a"..."z").contains(character)
    }
}
