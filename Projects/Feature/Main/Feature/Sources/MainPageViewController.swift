//
//  MainPageViewController.swift
//  FeatureMain
//
//  Created by choijunios on 1/27/25.
//

import RIBs
import RxSwift
import UIKit

protocol MainPagePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class MainPageViewController: UIViewController, MainPagePresentable, MainPageViewControllable, MainPageViewListener {

    private(set) var mainView: MainPageView!
    weak var listener: MainPagePresentableListener?
    
    override func loadView() {
        let mainView = MainPageView()
        self.mainView = mainView
        self.view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


// MARK: MainPageViewListener
extension MainPageViewController {
    
    func action(_ action: MainPageView.Action) {
    
    }
}


#Preview {
    let vc = MainPageViewController()
    vc.loadView()
    vc.mainView
        .update(orbitState: .luckScoreOverZero(userName: "준영"))
        .update(fortuneDeliveryTimeText: "내일 오전 5:00 도착")
        .update(turnOnFortuneNoti: true)
    return vc
}
