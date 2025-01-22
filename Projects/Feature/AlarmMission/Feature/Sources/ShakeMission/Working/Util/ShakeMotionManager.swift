//
//  ShakeMotionManager.swift
//  AlarmMission
//
//  Created by choijunios on 1/21/25.
//

import CoreMotion

final class ShakeDetecter {
    
    // Call back
    private let shakeAction: ()->Void
    
    
    // CMMotionManager
    private let motionManager = CMMotionManager()
    
    
    // State
    private let shakeThreshold: Double
    private let detectionInterval: Double
    
    
    init(shakeThreshold: Double, detectionInterval: Double, shakeAction: @escaping ()->Void) {
        self.shakeThreshold = shakeThreshold
        self.detectionInterval = detectionInterval
        self.shakeAction = shakeAction
    }
    
    private func handleAcceleration(data: CMAccelerometerData) {
        // 가속도 크기 계산 (벡터 크기)
        let x2 = pow(data.acceleration.x, 2)
        let y2 = pow(data.acceleration.y, 2)
        let z2 = pow(data.acceleration.z, 2)
        let accelerationMagnitude = sqrt(x2+y2+z2)
        
        // 임계값 초과 여부 확인
        if accelerationMagnitude > shakeThreshold { shakeAction() }
    }
}


// MARK: Public interface
extension ShakeDetecter {
    
    func startDetection() {
        
        if motionManager.isAccelerometerAvailable {
            
            motionManager.accelerometerUpdateInterval = self.detectionInterval
            motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
                guard let data = data, error == nil else { return }
                self?.handleAcceleration(data: data)
            }
        }
    }
    
    func stopDetection() {
        motionManager.stopAccelerometerUpdates()
    }
}
