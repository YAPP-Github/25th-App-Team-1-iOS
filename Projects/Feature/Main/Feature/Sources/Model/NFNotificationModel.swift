//
//  asd.swift
//  Main
//
//  Created by choijunios on 9/7/25.
//

import UIKit
import Foundation
import FeatureResources

struct NFNotificationModel {
    
    private let nfName = "select_mission_for_alarm"
    private let dateFormatter: DateFormatter = {
        let d = DateFormatter()
        d.dateFormat = "yyyy-MM-dd"
        return d
    }()
    
    var isShow: Bool {
        guard UserDefaults.standard.bool(forKey: keyForDonNotShowAgain) == false else { return false }

        guard let dateStr = UserDefaults.standard.string(forKey: keyForWatchedAt) else {
            // 확인 정보가 없는 경우 표출
            return true
        }
        
        let currentDateStr = dateFormatter.string(from: Date.now)
        
        // 본 날짜가 오늘이 아니라면 표출
        return currentDateStr != dateStr
    }
    
    var keyForDonNotShowAgain: String {
        "\(nfName)_dont_show_again"
    }
    
    var keyForWatchedAt: String {
        "\(nfName)_watched_at"
    }
    
    func checkWatchedToday(today: Date = .now) {
        let dateStr = dateFormatter.string(from: today)
        let key = keyForWatchedAt
        UserDefaults.standard.set(dateStr, forKey: key)
    }
    
    func checkDontShowAgain() {
        let key = keyForDonNotShowAgain
        UserDefaults.standard.set(true, forKey: key)
    }
    
    func getImage() -> UIImage {
        FeatureResourcesAsset.newFeatureSelectMissionForAlarmImage.image
    }
}
