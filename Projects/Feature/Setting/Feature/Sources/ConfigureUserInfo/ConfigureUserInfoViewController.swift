//
//  ConfigureUserInfoViewController.swift
//  FeatureSetting
//
//  Created by choijunios on 2/13/25.
//

import FeatureCommonEntity
import FeatureUIDependencies

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
    case setTimeIsUnknownState(isUnknown: Bool)
    case showBornTimeFieldErrorMessage
    case showNameFieldErrorMessage
    case dismissBornTimeFieldErrorMessage
    case dismissNameFieldErrorMessage
    case presentLoading
    case dismissLoading
}

protocol ConfigureUserInfoPresentableListener: AnyObject {
    func request(_ request: ConfigureUserInfoPresenterRequest)
}

final class ConfigureUserInfoViewController: UIViewController, ConfigureUserInfoPresentable, ConfigureUserInfoViewControllable, ConfigureUserInfoViewListener {
    
    private var mainView: ConfigureUserInfoView!
    private var loadingView: DSDefaultLoadingView?

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
            mainView.update(.saveButton(isEnabled: isEanbled))
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
            } else {
                mainView.update(.bornTime(text: ""))
            }
        case .showNameFieldErrorMessage:
            mainView.update(.nameFieldMsg(messageState: .error("입력한 내용을 확인해 주세요", .left)))
        case .dismissNameFieldErrorMessage:
            mainView.update(.nameFieldMsg(messageState: .none))
        case .showBornTimeFieldErrorMessage:
            mainView.update(.bornTimeFieldMsg(messageState: .error("입력한 숫자를 확인해 주세요", .left)))
        case .dismissBornTimeFieldErrorMessage:
            mainView.update(.bornTimeFieldMsg(messageState: .none))
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
        case .setTimeIsUnknownState(let isUnknown):
            if isUnknown {
                // 시간을 모르는 상태
                // - 공백처리, 체킹상태 변화, 텍스트 필드 비활성화
                mainView.update(.unknownTime(isChecked: true))
                mainView.update(.bornTimeFieldEnability(isEnabled: false))
            } else {
                // - 체킹상태 변화, 텍스트 필드 활성화
                mainView.update(.unknownTime(isChecked: false))
                mainView.update(.bornTimeFieldEnability(isEnabled: true))
            }
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
