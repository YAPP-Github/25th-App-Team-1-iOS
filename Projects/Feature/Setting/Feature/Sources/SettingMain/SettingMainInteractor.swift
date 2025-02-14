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
}

public protocol SettingMainRouting: ViewableRouting {
    func request(_ request: SettingMainRoutingRequest)
}

protocol SettingMainPresentable: Presentable {
    var listener: SettingMainPresentableListener? { get set }
    
    func update(_ update: SettingMainPresenterUpdate)
}

public protocol SettingMainListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SettingMainInteractor: PresentableInteractor<SettingMainPresentable>, SettingMainInteractable, SettingMainPresentableListener, ConfigureUserInfoListener {

    weak var router: SettingMainRouting?
    weak var listener: SettingMainListener?

    // State
    private var userInfo: UserInfo!
    
    
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
            // 로딩화면 시작
            presenter.update(.presentLoading)
            if let userId = Preference.userId {
                APIClient.request(
                    UserInfoResponseDTO.self,
                    request: APIRequest.Users.getUser(userId: userId),
                    success: { [weak self] userInfo in
                        guard let self else { return }
                        
                        let birthdateList = userInfo.birthDate.split(separator: "-")
                        let year = Year(Int(birthdateList[0])!)
                        let month = Month(rawValue: Int(birthdateList[1])!)!
                        let day = Day(Int(birthdateList[2])!, month: month, year: year)!
                        
                        var bornTimeData: BornTimeData?
                        if let bornTime = userInfo.birthTime {
                            let bornTimeList = bornTime.split(separator: ":")
                            let hour = Int(bornTimeList[0])!
                            let minute = Int(bornTimeList[1])!
                            
                            let meridiemEntity: Meridiem = hour >= 12 ? .pm : .am
                            var hourEntity: Hour!
                            if meridiemEntity == .pm {
                                hourEntity = .init(hour-12)!
                            } else {
                                hourEntity = .init(hour)!
                            }
                            let minuteEntity: Minute = .init(minute)!
                            bornTimeData = .init(
                                meridiem: meridiemEntity,
                                hour: hourEntity,
                                minute: minuteEntity
                            )
                        }
                        let userInfoEntity = UserInfo(
                            id: userId,
                            name: userInfo.name,
                            birthDate: .init(
                                calendarType: userInfo.calendarType == .lunar ? .lunar : .gregorian,
                                year: year,
                                month: month,
                                day: day
                            ),
                            birthTime: bornTimeData,
                            gender: userInfo.gender == .male ? .male : .female
                        )
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
            break
        case .presentPage(let id):
            break
        case .presentConfigureUserInfo:
            router?.request(.presentEditUserInfoPage(userInfo: userInfo, listener: self))
        case .presentOpinionPage:
            break
        case .exitPage:
            break
        }
    }
}


// MARK: ConfigureUserInfoListener
extension SettingMainInteractor {
    func dismiss(changed userInfo: UserInfo?) {
        if let userInfo {
            presenter.update(.setUserInfo(userInfo))
        }
        router?.request(.dismissEditUserInfoPage)
    }
}
