//
//  AuthorizationRequestService.swift
//  FeatureOnboarding
//
//  Created by ever on 1/11/25.
//

import Foundation
import UserNotifications

protocol AuthorizationRequestServiceable {
    func requestPermission(completion: @escaping ((Bool) -> Void))
}

struct AuthorizationRequestService: AuthorizationRequestServiceable {
    func requestPermission(completion: @escaping ((Bool) -> Void)) {
        requestNotificationAuthorization { granted, error in
            guard error == nil else {
                completion(false)
                return
            }
            completion(granted)
        }
        
    }
    
    private func requestNotificationAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            completion(granted, error)
        }
    }
}
