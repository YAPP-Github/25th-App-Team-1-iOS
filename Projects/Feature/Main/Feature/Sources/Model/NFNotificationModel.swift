//
//  asd.swift
//  Main
//
//  Created by choijunios on 9/7/25.
//

import UIKit
import Foundation
import FeatureResources
import RxSwift
import FeatureNetworking

struct NFNotificationModel {
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
    
    private var bundleVersion: String {
        let bundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return bundleVersion ?? "0.0.0"
    }
    
    var keyForDonNotShowAgain: String {
        "kNF_\(bundleVersion)_dont_show_again"
    }
    
    var keyForWatchedAt: String {
        "kNF_\(bundleVersion)_watched_at"
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
    
    func getImage() -> Observable<UIImage?> {
        guard let url = URL(string: "https://www.orbitalarm.net/images/ios/\(bundleVersion)/update-banner.png")
        else { return .just(nil) }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        return Single<UIImage?>.create { promise in
            let dataRequest = APIClient.request(request: urlRequest, success: { data in
                guard let image = UIImage(data: data) else {
                    print("신기능 홍보 이미지 변환 실패")
                    promise(.success(nil))
                    return
                }
                promise(.success(image))
            }, failure: { error in
                print("신기능 홍보 이미지 획득 실패 \(error.localizedDescription)")
                promise(.success(nil))
            })
            return Disposables.create {
                dataRequest.cancel()
            }
        }
        .asObservable()
    }
}
