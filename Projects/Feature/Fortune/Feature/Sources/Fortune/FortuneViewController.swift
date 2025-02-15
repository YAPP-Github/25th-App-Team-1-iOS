//
//  FortuneViewController.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import RIBs
import RxSwift
import UIKit
import FeatureUIDependencies

enum FortunePresentableListenerRequest {
    case viewDidLoad
    case close
}

protocol FortunePresentableListener: AnyObject {
    func request(_ request: FortunePresentableListenerRequest)
}

final class FortuneViewController: UIViewController, FortunePresentable, FortuneViewControllable {

    weak var listener: FortunePresentableListener?
    
    override func loadView() {
        view = step1View
    }
    
    override func viewDidLoad() {
        if let navBar = navigationController?.navigationBar {
            navBar.setBackgroundImage(UIImage(), for: .default)
            navBar.shadowImage = UIImage()
            navBar.isTranslucent = true
            navBar.backgroundColor = .clear
            navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
        
        title = "미래에서 온 편지"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: FeatureResourcesAsset.svgNavClose.image.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(closeButtonTapped))
        step1View.listener = self
        step2View.listener = self
        step3View.listener = self
        step4View.listener = self
        step5View.listener = self
        step6View.listener = self
        charmView.listener = self
        
        listener?.request(.viewDidLoad)
    }
    
    private let step1View = FortuneLetterView()
    private let step2View = FortuneStudyMoneyView()
    private let step3View = FortuneHealthLoveView()
    private let step4View = FortuneCoordinationView()
    private let step5View = FortuneReferenceView()
    private let step6View = CompleteWithFortuneView()
    private let charmView = CharmView()
    
    @objc
    private func closeButtonTapped() {
        listener?.request(.close)
    }
    
    func request(_ request: FortunePresentableRequest) {
        switch request {
        case let .setFortune(fortune, userInfo):
            step1View.update(.fortune(fortune))
            step2View.update(.fortune(fortune, userInfo))
            step3View.update(.fortune(fortune, userInfo))
            step4View.update(.fortune(fortune))
            step5View.update(.fortune(fortune))
            charmView.update(.user(userInfo))
        }
    }
}

extension FortuneViewController: FortuneLetterViewListener {
    func action(_ action: FortuneLetterView.Action) {
        view = step2View
    }
}

extension FortuneViewController: FortuneStudyMoneyViewListener {
    func action(_ action: FortuneStudyMoneyView.Action) {
        switch action {
        case .prev:
            view = step1View
        case .next:
            view = step3View
        }
    }
}

extension FortuneViewController: FortuneHealthLoveViewListener {
    func action(_ action: FortuneHealthLoveView.Action) {
        switch action {
        case .prev:
            view = step2View
        case .next:
            view = step4View
        }
    }
}

extension FortuneViewController: FortuneCoordinationViewListener {
    func action(_ action: FortuneCoordinationView.Action) {
        switch action {
        case .prev:
            view = step3View
        case .next:
            view = step5View
        }
    }
}

extension FortuneViewController: FortuneReferenceViewListener {
    func action(_ action: FortuneReferenceView.Action) {
        switch action {
        case .prev:
            view = step4View
        case .next:
            view = step6View
        }
    }
}

extension FortuneViewController: CompleteWithoutFortuneViewListener {
    func action(_ action: CompleteWithoutFortuneView.Action) {
        switch action {
        case .prev:
            view = step5View
        case .done:
            listener?.request(.close)
        }
    }
}

extension FortuneViewController: CompleteWithFortuneViewListener {
    func action(_ action: CompleteWithFortuneView.Action) {
        switch action {
        case .prev:
            view = step5View
        case .next:
            view = charmView
        }
    }
}

extension FortuneViewController: CharmViewListener {
    func action(_ action: CharmView.Action) {
        switch action {
        case .done:
            listener?.request(.close)
        }
    }
}
