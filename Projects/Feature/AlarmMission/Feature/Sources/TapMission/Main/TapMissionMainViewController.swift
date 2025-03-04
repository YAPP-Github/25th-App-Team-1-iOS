//
//  TapMissionMainViewController.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 3/4/25.
//

import FeatureUIDependencies

import RIBs
import RxSwift
import UIKit

protocol TapMissionMainPresentableListener: AnyObject {
    func request(_ request: TapMissionMainPresenterRequest)
}

enum TapMissionMainPresenterRequest {
    case startMission
    case exitPage
}

final class TapMissionMainViewController: UIViewController, TapMissionMainPresentable, TapMissionMainViewControllable, TapMissionMainViewListener {
    
    

    weak var listener: TapMissionMainPresentableListener?
    
    private(set) var mainView: TapMissionMainView?
    
    // - Loading
    private var loadingView: DSDefaultLoadingView?
    
    override func loadView() {
        let mainView = TapMissionMainView()
        self.mainView = mainView
        self.view = mainView
        mainView.listener = self
    }
    
    func request(_ request: TapMissionMainInteractorRequest) {
        switch request {
        case .presentLoading:
            if loadingView != nil { return }
            let loadingView = DSDefaultLoadingView()
            view.addSubview(loadingView)
            loadingView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            loadingView.layer.zPosition = 1000
            loadingView.play()
            self.loadingView = loadingView
        case .dismissLoading:
            guard let loadingView else { return }
            UIView.animate(withDuration: 0.35) {
                loadingView.alpha = 0
            } completion: { _ in
                loadingView.stop()
                loadingView.removeFromSuperview()
                self.loadingView = nil
            }
        }
    }
}


// MARK: TapMissionMainViewListener
extension TapMissionMainViewController {
    func action(_ action: TapMissionMainView.Action) {
        switch action {
        case .startMissionButtonClicked:
            listener?.request(.startMission)
        case .rejectMissionButtonClicked:
            listener?.request(.exitPage)
        }
    }
}
