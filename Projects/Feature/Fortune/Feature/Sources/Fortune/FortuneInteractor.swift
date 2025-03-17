//
//  FortuneInteractor.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import Foundation

import FeatureCommonDependencies
import FeatureLogger

import RIBs
import RxSwift

public protocol FortuneRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

enum FortunePresentableRequest {
    case setFortune(Fortune, UserInfo, FortuneSaveInfo)
}

protocol FortunePresentable: Presentable {
    var listener: FortunePresentableListener? { get set }
    func request(_ request: FortunePresentableRequest)
}

public enum FortuneListenerRequest {
    case close
}

public protocol FortuneListener: AnyObject {
    func request(_ request: FortuneListenerRequest)
}

final class FortuneInteractor: PresentableInteractor<FortunePresentable>, FortuneInteractable, FortunePresentableListener {
    // Dependency
    private let logger: Logger
    
    
    // State for log
    private var currentPageNumber: Int?
    
    
    weak var router: FortuneRouting?
    weak var listener: FortuneListener?

    init(
        presenter: FortunePresentable,
        fortune: Fortune,
        userInfo: UserInfo,
        fortuneInfo: FortuneSaveInfo,
        logger: Logger
    ) {
        self.fortune = fortune
        self.userInfo = userInfo
        self.fortuneInfo = fortuneInfo
        self.logger = logger
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    func request(_ request: FortunePresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            presenter.request(.setFortune(fortune, userInfo, fortuneInfo))
        case let .charmSelected(index):
            fortuneInfo.charmIndex = index
            UserDefaults.standard.setDailyFortune(info: fortuneInfo)
        case .currentPageNumber(let number):
            currentPageNumber = number
            if let fortunePageViewEvent = FortunePageViewEvent(rawValue: number) {
                let log = FortunePageViewEventBuilder(eventType: fortunePageViewEvent).build()
                logger.send(log)
            }
        case .endPage:
            let log = LogObjectBuilder(eventType: "fortune_complete").build()
            logger.send(log)
            listener?.request(.close)
        case .exitPage:
            if let currentPageNumber {
                let log = ExitFortuneLogBuilder(pageNumber: currentPageNumber).build()
                logger.send(log)
            }
            listener?.request(.close)
        }
    }
    
    private let fortune: Fortune
    private let userInfo: UserInfo
    private var fortuneInfo: FortuneSaveInfo
}
