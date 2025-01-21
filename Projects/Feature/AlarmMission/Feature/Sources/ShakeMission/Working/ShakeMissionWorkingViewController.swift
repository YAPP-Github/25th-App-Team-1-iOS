//
//  ShakeMissionWorkingViewController.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 1/20/25.
//

import RIBs
import RxSwift
import UIKit

protocol ShakeMissionWorkingPresentableListener: AnyObject {
    
    func request(_ request: ShakeMissionWorkingPresenterRequest)
}

enum ShakeMissionWorkingPresenterRequest {
    
    case startMission
}

final class ShakeMissionWorkingViewController: UIViewController, ShakeMissionWorkingPresentable, ShakeMissionWorkingViewControllable, ShakeMissionWorkingViewListener {

    private(set) var mainView: ShakeMissionWorkingView!
    
    weak var listener: ShakeMissionWorkingPresentableListener?
    
    override func loadView() {
        let mainView = ShakeMissionWorkingView()
        self.mainView = mainView
        self.view = mainView
        mainView.listener = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listener?.request(.startMission)
    }
}


// MARK: ShakeMissionWorkingPresentable
extension ShakeMissionWorkingViewController {
    
    func request(_ request: ShakeMissionWorkingInteractorRequest) {
        switch request {
        case .startShakeMissionFlow(let successShakeCount):
            mainView
                .update(progress: 0.0)
                .update(countText: "0")
                .update(titleText: "\(successShakeCount)회를 흔들어야 운세를 받아요")
                .update(missionState: .guide) { [weak self] in
                    guard let self else { return }
                    // Guide --> Working(쉐이킹 감지)
                    mainView.update(missionState: .working)
                }
        }
    }
}


// MARK: ShakeMissionWorkingViewListener
extension ShakeMissionWorkingViewController {
    
    func action(_ action: ShakeMissionWorkingView.Action) {
        
    }
}

#Preview {
    ShakeMissionWorkingViewController()
}
