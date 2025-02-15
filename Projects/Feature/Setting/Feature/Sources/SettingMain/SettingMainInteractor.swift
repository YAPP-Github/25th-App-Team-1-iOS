//
//  SettingMainInteractor.swift
//  FeatureSetting
//
//  Created by choijunios on 2/13/25.
//

import UIKit

import FeatureCommonDependencies
import FeatureNetworking

import RIBs
import RxSwift

public enum SettingMainRoutingRequest {
    case presentEditUserInfoPage(userInfo: UserInfo, listener: ConfigureUserInfoListener)
    case dismissEditUserInfoPage
    case presentWebPage(url: URL)
}

public protocol SettingMainRouting: ViewableRouting {
    func request(_ request: SettingMainRoutingRequest)
}

protocol SettingMainPresentable: Presentable {
    var listener: SettingMainPresentableListener? { get set }
    
    func update(_ update: SettingMainPresenterUpdate)
}

public protocol SettingMainListener: AnyObject {
    func dismiss()
}

final class SettingMainInteractor: PresentableInteractor<SettingMainPresentable>, SettingMainInteractable, SettingMainPresentableListener, ConfigureUserInfoListener {

    weak var router: SettingMainRouting?
    weak var listener: SettingMainListener?

    // State
    private var userInfo: UserInfo!
    private lazy var sections: [SettingSectionRO] = [
        SettingSectionRO(
            order: 0,
            titleText: "서비스 약관",
            items: [
                .init(id: 0, title: "이용약관", task: { [weak self] in
                    guard let self else { return }
                    let url = URL(string: "https://www.orbitalarm.net/terms.html")!
                    router?.request(.presentWebPage(url: url))
                }),
                .init(id: 1, title: "개인정보 처리방침", task: { [weak self] in
                    guard let self else { return }
                    let url = URL(string: "https://www.orbitalarm.net/privacy.html")!
                    router?.request(.presentWebPage(url: url))
                }),
            ]
        )
    ]
    
    
    override init(presenter: SettingMainPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}


// MARK: SettingMainPresentableListener
extension SettingMainInteractor {
    func request(_ request: SettingMainPresenterRequest) {
        switch request {
        case .viewDidLoad:
            // Sections
            presenter.update(.setSettingSection(sections))
            
            // Version
            if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                let versionText = "v.\(appVersion)"
                presenter.update(.setVersion(versionText: versionText))
            }
        case .viewWillAppear:
            loadUserInfo()
        case .exectureSectionItemTask(let sectionId, let id):
            guard let item = sections
                .first(where: { $0.id == sectionId })?
                .items.first(where: { $0.id == id }) else { return }
            item.task?()
        case .presentConfigureUserInfo:
            router?.request(.presentEditUserInfoPage(userInfo: userInfo, listener: self))
        case .presentOpinionPage:
            let url = URL(string: "http://pf.kakao.com/_YxiPsn/chat")!
            router?.request(.presentWebPage(url: url))
        case .exitPage:
            listener?.dismiss()
        }
    }
    
    private func loadUserInfo() {
        presenter.update(.presentLoading)
        if let userId = Preference.userId {
            APIClient.request(
                UserInfoResponseDTO.self,
                request: APIRequest.Users.getUser(userId: userId),
                success: { [weak self] userInfo in
                    guard let self else { return }
                    let userInfoEntity = userInfo.toUserInfo()
                    self.userInfo = userInfoEntity
                    presenter.update(.setUserInfo(userInfoEntity))
                    presenter.update(.dismissLoading)
                }) { [weak self] error in
                    guard let self else { return }
                    // 유저정보 획득 실패
                    debugPrint(error.localizedDescription)
                }
        } else {
            // 유저아이디가 없는 경우
        }
    }
}


// MARK: ConfigureUserInfoListener
extension SettingMainInteractor {
    func dismiss() {
        router?.request(.dismissEditUserInfoPage)
    }
}
