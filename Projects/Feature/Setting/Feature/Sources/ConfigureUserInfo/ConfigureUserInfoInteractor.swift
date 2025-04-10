//
//  ConfigureUserInfoInteractor.swift
//  FeatureSetting
//
//  Created by choijunios on 2/13/25.
//

import Foundation
import FeatureCommonDependencies
import FeatureUIDependencies
import FeatureNetworking

import RIBs
import RxSwift

enum ConfigureUserInfoRoutingRequest {
    case presentAlert(config: DSTwoButtonAlert.Config)
    case dismissAlert
    case presentEditBirthDatePage(birthDate: BirthDateData)
    case dismissEditBirthDatePage
}

protocol ConfigureUserInfoRouting: ViewableRouting {
    func request(_ request: ConfigureUserInfoRoutingRequest)
}

protocol ConfigureUserInfoPresentable: Presentable {
    var listener: ConfigureUserInfoPresentableListener? { get set }
    func update(_ update: ConfigureUserInfoPresenterUpdate)
}

public protocol ConfigureUserInfoListener: AnyObject {
    func dismiss()
}

final class ConfigureUserInfoInteractor: PresentableInteractor<ConfigureUserInfoPresentable>, ConfigureUserInfoInteractable, ConfigureUserInfoPresentableListener {

    weak var router: ConfigureUserInfoRouting?
    weak var listener: ConfigureUserInfoListener?
    
    
    // State
    private let initialUserInfo: UserInfo
    private var isBornTimeUnknown: Bool
    private var currentUserInfo: UserInfo {
        didSet { checkSaveEnablity() }
    }
    private var nameIsValid: Bool = true {
        didSet { checkSaveEnablity() }
    }
    private var bornTimeIsValid: Bool = true {
        didSet { checkSaveEnablity() }
    }
    
    
    // Helper
    private let helper = InputNameHelper()

    
    init(userInfo: UserInfo, presenter: ConfigureUserInfoPresentable) {
        self.initialUserInfo = userInfo
        self.currentUserInfo = userInfo
        self.isBornTimeUnknown = userInfo.birthTime == nil
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


// MARK: ConfigureUserInfoPresentableListener
extension ConfigureUserInfoInteractor {
    func request(_ request: ConfigureUserInfoPresenterRequest) {
        switch request {
        case .viewDidLoad:
            presenter.update(.setUserInfo(userInfo: initialUserInfo))
            presenter.update(.setTimeIsUnknownState(isUnknown: self.isBornTimeUnknown))
        case .save:
            presenter.update(.presentLoading)
            if let userId = Preference.userId {
//                let dto: UserInfoUpdateRequestDTO = .init(
//                    name: initialUserInfo.name != currentUserInfo.name ? currentUserInfo.name : nil,
//                    birthDate: initialUserInfo.birthDate != currentUserInfo.birthDate ? currentUserInfo.birthDate.toDateString() : nil,
//                    birthTime: initialUserInfo.birthTime != currentUserInfo.birthTime ? currentUserInfo.birthTime?.toTimeString() : nil,
//                    gender: initialUserInfo.gender != currentUserInfo.gender ? currentUserInfo.gender.rawValue : nil,
//                    calendarType: initialUserInfo.birthDate != currentUserInfo.birthDate ? currentUserInfo.birthDate.calendarType.rawValue : nil
//                )
                let dto: UserInfoUpdateRequestDTO = .init(
                    name: currentUserInfo.name,
                    birthDate: currentUserInfo.birthDate.toDateString(),
                    birthTime: currentUserInfo.birthTime?.toTimeString(),
                    gender: currentUserInfo.gender.rawValue,
                    calendarType: currentUserInfo.birthDate.calendarType.rawValue
                )
                APIClient.request(
                    request: APIRequest.Users.updateUser(
                        userId: userId,
                        updateInfo: dto
                    ),
                    success: { [weak self] in
                        guard let self else { return }
                        presenter.update(.dismissLoading)
                        listener?.dismiss()
                    },
                    failure: { [weak self] error in
                        guard let self else { return }
                        debugPrint(error.localizedDescription)
                        presenter.update(.dismissLoading)
                        listener?.dismiss()
                    }
                )
            }
            
        case .back:
            let isChanged = initialUserInfo != currentUserInfo
            if isChanged {
                // 변경사항이 있는 경우 Alert표출
                let config = DSTwoButtonAlert.Config(
                    titleText: "변경 사항 삭제",
                    subTitleText: "변경 사항을 저장하지 않고\n나가시겠어요?",
                    leftButtonText: "취소",
                    rightButtonText: "나가기",
                    leftButtonTapped: { [weak self] in
                        guard let self else { return }
                        router?.request(.dismissAlert)
                    },
                    rightButtonTapped: { [weak self] in
                        guard let self else { return }
                        router?.request(.dismissAlert)
                        listener?.dismiss()
                    }
                )
                router?.request(.presentAlert(config: config))
            } else {
                listener?.dismiss()
            }
        case .editName(let text):
            self.nameIsValid = false
            guard validateNameLength(text) else {
                presenter.update(.showNameFieldErrorMessage)
                return
            }
            guard validateName(text) else {
                presenter.update(.showNameFieldErrorMessage)
                return
            }
            self.nameIsValid = true
            self.currentUserInfo.name = text
            presenter.update(.dismissNameFieldErrorMessage)
            presenter.update(.setUserInfo(userInfo: currentUserInfo))
        case .editBirthDate:
            router?.request(.presentEditBirthDatePage(birthDate: currentUserInfo.birthDate))
        case .editBornTime(let text):
            self.bornTimeIsValid = false
            guard checkTimeLength(text) else {
                presenter.update(.showBornTimeFieldErrorMessage)
                return
            }
            guard let (meridiem, hour) = validateHour(text),
                  let minute = validateMinute(text) else {
                presenter.update(.showBornTimeFieldErrorMessage)
                return
            }
            self.bornTimeIsValid = true
            self.currentUserInfo.birthTime = .init(meridiem: meridiem, hour: hour, minute: minute)
            presenter.update(.dismissBornTimeFieldErrorMessage)
            presenter.update(.setUserInfo(userInfo: currentUserInfo))
        case .editGender(let gender):
            self.currentUserInfo.gender = gender
            presenter.update(.setUserInfo(userInfo: currentUserInfo))
        case .changeBornTimeUnknownState:
            let current = self.isBornTimeUnknown
            let next = !current
            self.isBornTimeUnknown = next
            if next {
                // 시간모름 상태로 변경
                self.bornTimeIsValid = true
                self.currentUserInfo.birthTime = nil
                presenter.update(.setTimeIsUnknownState(isUnknown: true))
                presenter.update(.setUserInfo(userInfo: currentUserInfo))
            } else {
                // 시간 모름상태 해제, 하지만 공백으로 인해 검증은 실패한 상태
                self.bornTimeIsValid = false
                presenter.update(.setTimeIsUnknownState(isUnknown: false))
            }
        }
    }
    
    
    private func checkSaveEnablity() {
        let isChanged = initialUserInfo != currentUserInfo
        let isSavable = isChanged && nameIsValid && bornTimeIsValid
        presenter.update(.setSaveButtonState(isEanbled: isSavable))
    }
}


// MARK: Name validation
private extension ConfigureUserInfoInteractor {
    func validateNameLength(_ name: String) -> Bool {
        return name.count >= 1
    }
    
    func validateName(_ name: String) -> Bool {
        guard let helper else { return false }
        return helper.isWithinMaxLength(name)
    }
}


// MARK: Born time validation
private extension ConfigureUserInfoInteractor {
    func checkTimeLength(_ time: String) -> Bool {
        let text = time.replacingOccurrences(of: ":", with: "")
        return text.count == 4
    }
    
    func validateHour(_ time: String) -> (Meridiem, Hour)? {
        let hourString = time.prefix(2)
        guard var hourInt = Int(hourString),
              (0...23).contains(hourInt) else { return nil }
        let meridiem: Meridiem = hourInt < 12 ? .am : .pm
        if hourInt == 0 {
            hourInt = 12
        } else if hourInt > 12 {
            hourInt -= 12
        }
        guard let hour = Hour(hourInt) else { return nil }
        
        return (meridiem, hour)
    }
    
    func validateMinute(_ time: String) -> Minute? {
        let minute = time.suffix(2)
        guard let minuteInt = Int(minute),
              (0...59).contains(minuteInt),
              let minute = Minute(minuteInt)
        else { return nil }
        
        return minute
    }
}


// MARK: ConfigureBirthDateViewControllerListener
extension ConfigureUserInfoInteractor {
    func dismiss() {
        router?.request(.dismissEditBirthDatePage)
    }
    func changedBirthDateConfirmed(date changed: BirthDateData) {
        currentUserInfo.birthDate = changed
        presenter.update(.setUserInfo(userInfo: currentUserInfo))
    }
}
