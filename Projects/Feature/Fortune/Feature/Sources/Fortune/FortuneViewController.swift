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
    case currentPageNumber(Int)
    case charmSelected(Int)
    case exitPage
    case endPage
    case saveCharmToAlbumAndExit(image: UIImage)
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
        charmView.listener = self
        
        listener?.request(.viewDidLoad)
        listener?.request(.currentPageNumber(1))
    }
    
    private let step1View = FortuneLetterView()
    private let step2View = FortuneStudyMoneyView()
    private let step3View = FortuneHealthLoveView()
    private let step4View = FortuneCoordinationView()
    private let step5View = FortuneReferenceView()
    private var step6View: UIView?
    private lazy var withoutFortuneView = CompleteWithoutFortuneView()
    private lazy var withFortuneView = CompleteWithFortuneView()
    private let charmView = CharmView()
    
    @objc
    private func closeButtonTapped() {
        listener?.request(.exitPage)
    }
    
    func request(_ request: FortunePresentableRequest) {
        switch request {
        case let .setFortune(fortune, userInfo, fortuneInfo):
            step1View.update(.fortune(fortune))
            step2View.update(.fortune(fortune, userInfo))
            step3View.update(.fortune(fortune, userInfo))
            step4View.update(.fortune(fortune))
            step5View.update(.fortune(fortune))
            
            step6View = withFortuneView
            withFortuneView.listener = self
            charmView.update(.user(userInfo))
            charmView.update(.charm(fortuneInfo))
            
//            if fortuneInfo.shouldShowCharm {
//                step6View = withFortuneView
//                withFortuneView.listener = self
//                charmView.update(.user(userInfo))
//                charmView.update(.charm(fortuneInfo))
//            } else {
//                step6View = withoutFortuneView
//                withoutFortuneView.listener = self
//            }
            
        }
    }
}

extension FortuneViewController: FortuneLetterViewListener {
    func action(_ action: FortuneLetterView.Action) {
        view = step2View
        listener?.request(.currentPageNumber(2))
    }
}

extension FortuneViewController: FortuneStudyMoneyViewListener {
    func action(_ action: FortuneStudyMoneyView.Action) {
        switch action {
        case .prev:
            view = step1View
            listener?.request(.currentPageNumber(1))
        case .next:
            view = step3View
            listener?.request(.currentPageNumber(3))
        }
    }
}

extension FortuneViewController: FortuneHealthLoveViewListener {
    func action(_ action: FortuneHealthLoveView.Action) {
        switch action {
        case .prev:
            view = step2View
            listener?.request(.currentPageNumber(2))
        case .next:
            view = step4View
            listener?.request(.currentPageNumber(4))
        }
    }
}

extension FortuneViewController: FortuneCoordinationViewListener {
    func action(_ action: FortuneCoordinationView.Action) {
        switch action {
        case .prev:
            view = step3View
            listener?.request(.currentPageNumber(3))
        case .next:
            view = step5View
            listener?.request(.currentPageNumber(5))
        }
    }
}

extension FortuneViewController: FortuneReferenceViewListener {
    func action(_ action: FortuneReferenceView.Action) {
        switch action {
        case .prev:
            view = step4View
            listener?.request(.currentPageNumber(4))
        case .next:
            view = step6View
            listener?.request(.currentPageNumber(6))
        }
    }
}

extension FortuneViewController: CompleteWithoutFortuneViewListener {
    func action(_ action: CompleteWithoutFortuneView.Action) {
        switch action {
        case .prev:
            view = step5View
            listener?.request(.currentPageNumber(5))
        case .done:
            listener?.request(.endPage)
        }
    }
}

extension FortuneViewController: CompleteWithFortuneViewListener {
    func action(_ action: CompleteWithFortuneView.Action) {
        switch action {
        case .prev:
            view = step5View
            listener?.request(.currentPageNumber(5))
        case .next:
            view = charmView
            listener?.request(.currentPageNumber(7))
        }
    }
}

extension FortuneViewController: CharmViewListener {
    func action(_ action: CharmView.Action) {
        switch action {
        case let .saveToAlbumTapped(image):
            listener?.request(.saveCharmToAlbumAndExit(image: image))
        case .done:
            listener?.request(.endPage)
        case let .charmSelected(index):
            listener?.request(.charmSelected(index))
        }
    }
}
