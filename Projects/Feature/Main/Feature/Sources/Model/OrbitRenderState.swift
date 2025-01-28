//
//  OrbitRenderState.swift
//  Main
//
//  Created by choijunios on 1/28/25.
//

import Foundation

import FeatureResources

enum OrbitRenderState {
    
    case beforeFortune
    case luckScoreOver80
    case luckScoreOver50
    case luckScoreOverZero
    
    /// 말풍선에 들어갈 텍스트 입니다.
    var bubbleSpeechKorText: String {
        switch self {
        case .beforeFortune:
            "안녕, 난 오르비야!"
        case .luckScoreOver80:
            "행운이 가득할거야!"
        case .luckScoreOver50:
            "오늘은 다 잘될거야!"
        case .luckScoreOverZero:
            "오늘 하루도 힘내"
        }
    }
    
    /// 오르비의 로티 모션 경로(filePath)입니다.
    var orbitMotionLottieFilePath: String {
        let lottileBundle = Bundle.resources
        switch self {
        case .beforeFortune:
            return lottileBundle.path(forResource: "mainPage_BeforeFortune", ofType: "json")!
        case .luckScoreOver80:
            return lottileBundle.path(forResource: "mainPage_LuckScoreOver50", ofType: "json")!
        case .luckScoreOver50:
            return lottileBundle.path(forResource: "mainPage_LuckScoreOver80", ofType: "json")!
        case .luckScoreOverZero:
            return lottileBundle.path(forResource: "mainPage_LuckScoreOverZero", ofType: "json")!
        }
    }
}
