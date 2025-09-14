//
//  Tests.swift
//
//

import XCTest
import Foundation
@testable import FeatureMain

final class NFNotificationModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        clearUserDefaults()
    }

    override func tearDown() {
        clearUserDefaults()
    }

    /// 테스트 후 UserDefaults에 남아있는 값을 제거합니다.
    private func clearUserDefaults() {
        let model = NFNotificationModel()
        UserDefaults.standard.removeObject(forKey: model.keyForWatchedAt)
        UserDefaults.standard.removeObject(forKey: model.keyForDonNotShowAgain)
    }

    func test_오늘안봐도_다시는보지않음_선택시() {
        // Given
        let sut = NFNotificationModel()
        
        // When
        sut.checkDontShowAgain()
        
        // Then
        XCTAssertFalse(sut.isShow, "다시는 보지 않음이 보여줌 여부를 우선적으로 결정해야합니다.")
    }
    
    func test_오늘본경우() {
        // Given
        let sut = NFNotificationModel()
        
        // When
        sut.checkWatchedToday()
        
        // Then
        XCTAssertFalse(sut.isShow, "오늘 본 경우 isShow값은 false여야 합니다.")
    }
    
    func test_어제본경우() {
        // Given
        let sut = NFNotificationModel()
         
        // When
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        sut.checkWatchedToday(today: yesterday)
        
        // Then
        XCTAssertTrue(sut.isShow, "어제 본 경우 isShow값은 true여야 합니다.")
    }
}
