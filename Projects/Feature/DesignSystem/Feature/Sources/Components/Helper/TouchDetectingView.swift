//
//  TouchDetectingView.swift
//  FeatureDesignSystem
//
//  Created by ever on 1/11/25.
//

import UIKit

public class TouchDetectingView: UIView {
    
    func onTouchIn() {}
    func onTouchOut() {}
    
    private var isTouchInside = false
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            let location = touch.location(in: self)
            if self.bounds.contains(location) {
                isTouchInside = true
                onTouchIn()
            }
        }
    }
    
//    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesMoved(touches, with: event)
//        if let touch = touches.first {
//            let location = touch.location(in: self)
//            let currentlyInside = self.bounds.contains(location)
//            
//            if currentlyInside && !isTouchInside {
//                isTouchInside = true
//                onTouchIn()
//            } else if !currentlyInside && isTouchInside {
//                isTouchInside = false
//                onTouchOut()
//            }
//        }
//    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if isTouchInside {
            isTouchInside = false
            onTouchOut()
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if isTouchInside {
            isTouchInside = false
            onTouchOut()
        }
    }
}
