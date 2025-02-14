//
//  SettingMainViewController.swift
//  FeatureSetting
//
//  Created by choijunios on 2/13/25.
//

import FeatureCommonDependencies
import FeatureUIDependencies
import FeatureThirdPartyDependencies

import RIBs
import RxSwift
import UIKit

enum SettingMainPresenterRequest {
    case viewDidLoad
    case viewWillAppear
    case exectureSectionItemTask(sectionId: Int, id: Int)
    case presentConfigureUserInfo
    case presentOpinionPage
    case exitPage
}

enum SettingMainPresenterUpdate {
    case setUserInfo(UserInfo)
    case setSettingSection([SettingSectionRO])
    case presentLoading
    case dismissLoading
}

protocol SettingMainPresentableListener: AnyObject {
    func request(_ request: SettingMainPresenterRequest)
}

final class SettingMainViewController: UIViewController, SettingMainPresentable, SettingMainViewControllable, SettingMainViewListener {
    // Sub view
    private var mainView: SettingMainView!
    private var loadingView: DSDefaultLoadingView?
    
    weak var listener: SettingMainPresentableListener?
    
    
    override func loadView() {
        let mainView = SettingMainView()
        mainView.listener = self
        self.mainView = mainView
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listener?.request(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listener?.request(.viewWillAppear)
    }
}


// MARK: Public interface
extension SettingMainViewController {
    func update(_ update: SettingMainPresenterUpdate) {
        switch update {
        case .setSettingSection(let sectionROs):
            mainView.update(.sections(sections: sectionROs))
        case .setUserInfo(let info):
            let birthDateText = "\(info.birthDate.year.value)년 \(info.birthDate.month.rawValue)월 \(info.birthDate.day.value)일"
            var bornTimeText: String?
            if let birthTime = info.birthTime {
                var hourText = String(birthTime.hour.value)
                if birthTime.meridiem == .pm {
                    hourText = String(birthTime.hour.value+12)
                }
                bornTimeText = "\(hourText)시 \(birthTime.minute.value)분"
            }
            let userInfoRO = UserInfoCardRO(
                nameText: info.name,
                genderText: info.gender.displayingName,
                lunarText: info.birthDate.calendarType.displayKoreanText,
                birthDateText: birthDateText,
                bornTimeText: bornTimeText
            )
            mainView.update(.userInfoCard(userInfo: userInfoRO))
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


// MARK: SettingMainViewListener
extension SettingMainViewController {
    func action(_ action: SettingMainView.Action) {
        switch action {
        case .settingItemIsTapped(let sectionId, let rowId):
            listener?.request(.exectureSectionItemTask(sectionId: sectionId, id: rowId))
        case .opinionButtonTapped:
            listener?.request(.presentOpinionPage)
        case .userInfoCardTapped:
            listener?.request(.presentConfigureUserInfo)
        case .backButtonTapped:
            listener?.request(.exitPage)
        }
    }
}


#Preview {
    let vc = SettingMainViewController()
    vc.loadView()
    return vc
}
