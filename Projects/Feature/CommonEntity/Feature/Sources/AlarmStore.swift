//
//  OldAlarmStore.swift
//  FeatureCommonEntity
//
//  Created by ever on 2/7/25.
//

import Foundation

public final class OldAlarmStore {
    public static let shared = OldAlarmStore()
    
    private let userDefaults = UserDefaults.standard
    private let storageKey = "alarms" // 저장 키
    
    // 메모리 내 알람 리스트
    private(set) var alarms: [Alarm] = []
    
    private init() {
        loadAlarms()
    }
    
    // MARK: - CRUD Methods
    
    /// Create: 새 알람 추가
    public func add(_ alarm: Alarm) {
        alarms.append(alarm)
        saveAlarms()
    }
    
    /// Read: 모든 알람 조회
    public func getAll() -> [Alarm] {
        return alarms
    }
    
    /// Update: 기존 알람 수정 (id를 기준으로)
    public func update(_ alarm: Alarm) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index] = alarm
            saveAlarms()
        }
    }
    
    /// Delete: 알람 삭제 (id를 기준으로)
    public func delete(_ alarm: Alarm) {
        alarms.removeAll { $0.id == alarm.id }
        saveAlarms()
    }
    
    // MARK: - Persistence Methods
    
    /// 현재 메모리의 알람 데이터를 UserDefaults에 저장
    private func saveAlarms() {
        do {
            let data = try JSONEncoder().encode(alarms)
            userDefaults.set(data, forKey: storageKey)
        } catch {
            print("알람 저장 실패: \(error)")
        }
    }
    
    /// UserDefaults에 저장된 알람 데이터를 불러와 메모리에 로드
    private func loadAlarms() {
        guard let data = userDefaults.data(forKey: storageKey) else { return }
        do {
            alarms = try JSONDecoder().decode([Alarm].self, from: data)
        } catch {
            print("알람 불러오기 실패: \(error)")
        }
    }
}
