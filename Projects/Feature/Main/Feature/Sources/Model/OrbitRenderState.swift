//
//  OrbitRenderState.swift
//  Main
//
//  Created by choijunios on 1/28/25.
//

import Foundation

import FeatureResources

enum OrbitRenderState {
    case emptyAlarm
    case beforeFortune
    case luckScoreOver80(userName: String)
    case luckScoreOver50(userName: String)
    case luckScoreOverZero(userName: String)
    
    /// 말풍선에 들어갈 텍스트 입니다.
    var bubbleSpeechKorText: String {
        switch self {
        case .emptyAlarm:
            "알람을 설정해줘.."
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
        case .emptyAlarm:
            return lottileBundle.path(forResource: "", ofType: "")!
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
    
    
    /// 오르비가 전해주는 운세기반 텍스트입니다.
    var orbitFortuneBaseKorText: String {
        switch self {
        case .emptyAlarm:
            "미래에서 운세 편지를\n작성 중이야!"
        case .beforeFortune:
            "미래에서 운세 편지를\n작성 중이야!"
        case .luckScoreOver80(let userName):
            "오늘 \(userName)의 하루는\n누구보다 빛나!"
        case .luckScoreOver50(let userName):
            "오늘 \(userName)의 하루는\n최고야!"
        case .luckScoreOverZero(let userName):
            "오늘 \(userName)의 하루는\n주의가 필요해"
        }
    }
}
