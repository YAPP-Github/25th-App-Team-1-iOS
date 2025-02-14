//
//  ConfigureUserInfoViewController.swift
//  FeatureSetting
//
//  Created by choijunios on 2/13/25.
//

import FeatureCommonEntity

import RIBs
import RxSwift
import UIKit

enum ConfigureUserInfoPresenterRequest {
    case viewDidLoad
    case save
    case back
    case editName(text: String)
    case editBirthDate
    case editBornTime(text: String)
    case editGender(gender: Gender)
    case changeBornTimeUnknownState
}

enum ConfigureUserInfoPresenterUpdate {
    case setSaveButtonState(isEanbled: Bool)
    case setUserInfo(userInfo: UserInfo)
    case showBornTimeFieldErrorMessage
    case showNameFieldErrorMessage
    case dismissBornTimeFieldErrorMessage
    case dismissNameFieldErrorMessage
}

protocol ConfigureUserInfoPresentableListener: AnyObject {
    func request(_ request: ConfigureUserInfoPresenterRequest)
}

final class ConfigureUserInfoViewController: UIViewController, ConfigureUserInfoPresentable, ConfigureUserInfoViewControllable, ConfigureUserInfoViewListener {
    
    private var mainView: ConfigureUserInfoView!

    weak var listener: ConfigureUserInfoPresentableListener?
    
    override func loadView() {
        let mainView = ConfigureUserInfoView()
        mainView.listener = self
        self.mainView = mainView
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listener?.request(.viewDidLoad)
    }
}


// MARK: Public inteface
extension ConfigureUserInfoViewController {
    func update(_ update: ConfigureUserInfoPresenterUpdate) {
        switch update {
        case .setSaveButtonState(let isEanbled):
            break
        case .setUserInfo(let userInfo):
            // name
            mainView.update(.name(text: userInfo.name))
            
            // birthDate
            let birthDate = userInfo.birthDate
            let birthDateText = "\(birthDate.calendarType.displayKoreanText) \(birthDate.year.value)년 \(birthDate.month.rawValue)월 \(birthDate.day.value)일"
            mainView.update(.birthDate(text: birthDateText))
            
            // gender
            mainView.update(.gender(gender: userInfo.gender))
            
            // bornTime
            if let bornTimeData = userInfo.birthTime {
                let bornTimeText = bornTimeData.toTimeString()
                mainView.update(.bornTime(text: bornTimeText))
                mainView.update(.unknownTime(isChecked: false))
            } else {
                mainView.update(.unknownTime(isChecked: true))
            }
        case .showNameFieldErrorMessage:
            mainView.update(.nameFieldMsg(messageState: .error("입력한 내용을 확인해 주세요", .left)))
        case .dismissNameFieldErrorMessage:
            mainView.update(.nameFieldMsg(messageState: .none))
        case .showBornTimeFieldErrorMessage:
            mainView.update(.bornTimeFieldMsg(messageState: .error("입력한 숫자를 확인해 주세요", .left)))
        case .dismissBornTimeFieldErrorMessage:
            mainView.update(.bornTimeFieldMsg(messageState: .none))
        }
    }
}


// MARK: ConfigureUserInfoListener
extension ConfigureUserInfoViewController {
    func action(_ action: ConfigureUserInfoView.Action) {
        switch action {
        case .saveButtonTapped:
            listener?.request(.save)
        case .backButtonTapped:
            listener?.request(.back)
        case .nameTextChanged(let text):
            listener?.request(.editName(text: text))
        case .editBirthDateButtonTapped:
            listener?.request(.editBirthDate)
        case .genderButtonTapped(let gender):
            listener?.request(.editGender(gender: gender))
        case .bornTimeTextChanged(let text):
            listener?.request(.editBornTime(text: text))
        case .unknownBornTimeTapped:
            listener?.request(.changeBornTimeUnknownState)
        }
    }
}


#Preview {
    ConfigureUserInfoViewController()
}
