//
//  TouchDetectingView.swift
//  FeatureDesignSystem
//
//  Created by ever on 1/11/25.
//

import UIKit

import UIKit

open class TouchDetectingView: UIView {

    // 클릭, 왼쪽 스와이프, 오른쪽 스와이프 이벤트를 처리할 함수들
    open func onTouchIn() {}
    open func onTouchOut(isInbound: Bool?) {}
    open func onTap() {}
    open func onSwipeLeft() {}
    open func onSwipeRight() {}

    private var initialTouchLocation: CGPoint = .zero

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // 첫 번째 터치의 위치를 기록
        if let touch = touches.first {
            onTouchIn()
            initialTouchLocation = touch.location(in: self)
        }
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        // 터치 이동 시 좌우 스와이프 감지
        if let touch = touches.first {
            let currentLocation = touch.location(in: self)
            let deltaX = currentLocation.x - initialTouchLocation.x
            
            if deltaX > 50 {  // 오른쪽 스와이프
                onSwipeRight()
                initialTouchLocation = currentLocation  // 새로운 시작점으로 갱신
            } else if deltaX < -50 {  // 왼쪽 스와이프
                onSwipeLeft()
                initialTouchLocation = currentLocation  // 새로운 시작점으로 갱신
            }
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        // 터치가 끝났을 때 클릭 이벤트 발생
        if let touch = touches.first {
            onTouchOut(isInbound: judgeTouchIsInbound(touch))
            let currentLocation = touch.location(in: self)
            if currentLocation == initialTouchLocation {
                onTap()
            }
        }
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        // 터치가 취소되었을 때 처리
        onTouchCancelled()
        if let touch = touches.first { onTouchOut(isInbound: judgeTouchIsInbound(touch)) }
        else { onTouchOut(isInbound: nil) }
    }
    
    // 터치 취소 시 처리할 함수
    open func onTouchCancelled() {}
    
    
    private func judgeTouchIsInbound(_ touch: UITouch) -> Bool {
        let currentLocation = touch.location(in: self)
        let xPos = currentLocation.x
        let yPos = currentLocation.y
        let inbound_on_horizontality = 0 <= xPos && xPos <= self.bounds.width
        let inbound_on_verticality = 0 <= yPos && yPos <= self.bounds.height
        let isInbound = inbound_on_horizontality && inbound_on_verticality
        return isInbound
    }
}
