//
//  InputSummaryViewController.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/15/25.
//

import RIBs
import RxSwift
import UIKit

enum InputSummaryViewRequest {
    
    case viewDidAppear
    case confirmInputs
    case backToEditInputs
}

protocol InputSummaryPresentableListener: AnyObject {
    
    func request(_ request: InputSummaryViewRequest)
}

final class InputSummaryViewController: UIViewController, InputSummaryPresentable, InputSummaryViewControllable, InputSummaryViewListener {
    
    private(set) var mainView: InputSummaryView!
    
    weak var listener: InputSummaryPresentableListener?
    
    override func loadView() {
        self.mainView = InputSummaryView()
        self.view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listener?.request(.viewDidAppear)
    }
}


// MARK: Public interface
extension InputSummaryViewController {
    
    func update(inputs: [String: String]) {
        mainView.update(inputs: inputs)
    }
    
    func presentMainView(onBoadingModel: OnboardingModel, animated: Bool) {
        
        var inputsViewModel: [String: String] = [:]
        
        if let name = onBoadingModel.name {
            inputsViewModel["이름"] = name
        }
        if let gender = onBoadingModel.gender {
            inputsViewModel["성별"] = gender.displayingName
        }
        if let birthDate = onBoadingModel.birthDate {
            let birthDateText = "\(birthDate.calendarType.displayKoreanText) \(birthDate.year)년 \(birthDate.month)월 \(birthDate.day)일"
            inputsViewModel["생년월일"] = birthDateText
        }
        if let bornTime = onBoadingModel.bornTime {
            let bornTimeText = "\(bornTime.hours)시 \(bornTime.minutes)분"
            inputsViewModel["태어난 시간"] = bornTimeText
        } else {
            inputsViewModel["태어난 시간"] = "몰라요"
        }
        
        mainView.update(inputs: inputsViewModel)
        mainView.update(isPresent: false)
        mainView.alpha = 1
        UIView.animate(withDuration: animated ? 0.35 : 0.0) {
            self.mainView.update(isPresent: true)
        }
    }
    
    func dismissMainView(animated: Bool, completion: @escaping () -> Void) {
        
        UIView.animate(withDuration: animated ? 0.35 : 0.0) {
            self.mainView.update(isPresent: false)
        } completion: { _ in
            completion()
        }
    }
}


// MARK: InputSummaryViewListener
extension InputSummaryViewController {
    
    func action(_ action: InputSummaryView.Action) {
        switch action {
        case .agreeInSumamry:
            listener?.request(.confirmInputs)
        case .disagreeInSummary:
            listener?.request(.backToEditInputs)
        }
    }
}
