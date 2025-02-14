//
//  ConfigureUserInfoInteractor.swift
//  FeatureSetting
//
//  Created by choijunios on 2/13/25.
//

import FeatureCommonDependencies

import RIBs
import RxSwift

protocol ConfigureUserInfoRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ConfigureUserInfoPresentable: Presentable {
    var listener: ConfigureUserInfoPresentableListener? { get set }
    func update(_ update: ConfigureUserInfoPresenterUpdate)
}

public protocol ConfigureUserInfoListener: AnyObject {
    func dismiss(changed: UserInfo?)
}

final class ConfigureUserInfoInteractor: PresentableInteractor<ConfigureUserInfoPresentable>, ConfigureUserInfoInteractable, ConfigureUserInfoPresentableListener {

    weak var router: ConfigureUserInfoRouting?
    weak var listener: ConfigureUserInfoListener?
    
    
    // State
    private let initialUserInfo: UserInfo
    private var currentUserInfo: UserInfo
    private var nameIsValid: Bool = true
    private var bornTimeIsValid: Bool = true
    
    
    // Helper
    private let helper = InputNameHelper()

    
    init(userInfo: UserInfo, presenter: ConfigureUserInfoPresentable) {
        self.initialUserInfo = userInfo
        self.currentUserInfo = userInfo
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
        case .save:
            break
        case .back:
            let isChanged = initialUserInfo != currentUserInfo
            listener?.dismiss(changed: isChanged ? currentUserInfo : nil)
        case .editName(let text):
            guard validateNameLength(text) else {
                self.nameIsValid = false
                presenter.update(.showNameFieldErrorMessage)
                return
            }
            guard validateName(text) else {
                self.nameIsValid = false
                presenter.update(.showNameFieldErrorMessage)
                return
            }
            self.nameIsValid = true
            self.currentUserInfo.name = text
            presenter.update(.setUserInfo(userInfo: currentUserInfo))
            checkSaveEnablity()
        case .editBirthDate:
            checkSaveEnablity()
        case .editBornTime(let text):
            guard checkTimeLength(text) else {
                self.bornTimeIsValid = false
                presenter.update(.showBornTimeFieldErrorMessage)
                return
            }
            guard let (meridiem, hour) = validateHour(text),
                  let minute = validateMinute(text) else {
                self.bornTimeIsValid = false
                presenter.update(.showBornTimeFieldErrorMessage)
                return
            }
            self.bornTimeIsValid = true
            self.currentUserInfo.birthTime = .init(meridiem: meridiem, hour: hour, minute: minute)
            presenter.update(.setUserInfo(userInfo: currentUserInfo))
            checkSaveEnablity()
        case .editGender(let gender):
            self.currentUserInfo.gender = gender
            presenter.update(.setUserInfo(userInfo: currentUserInfo))
            checkSaveEnablity()
        case .changeBornTimeUnknownState:
            self.bornTimeIsValid = true
            self.currentUserInfo.birthTime = nil
            presenter.update(.setUserInfo(userInfo: currentUserInfo))
            checkSaveEnablity()
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
        guard let hourInt = Int(hourString),
              (0...23).contains(hourInt) else { return nil }
        let meridiem: Meridiem = hourInt < 12 ? .am : .pm
        switch meridiem {
        case .am:
            guard let hour = Hour(hourInt) else { return nil }
            return (meridiem, hour)
        case .pm:
            guard let hour = Hour(hourInt - 12) else { return nil }
            return (meridiem, hour)
        }
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
