//
//  CreateAlarmSoundOptionViewController.swift
//  FeatureAlarm
//
//  Created by ever on 1/26/25.
//

import RIBs
import RxSwift
import UIKit

enum CreateAlarmSoundOptionPresentableListenerRequest {
    case isVibrateOnChanged(Bool)
    case isSoundOnChanged(Bool)
    case volumeChanged(Float)
    case soundSelected(String)
    case done
}
protocol CreateAlarmSoundOptionPresentableListener: AnyObject {
    func request(_ request: CreateAlarmSoundOptionPresentableListenerRequest)
}

final class CreateAlarmSoundOptionViewController: UIViewController, CreateAlarmSoundOptionPresentable, CreateAlarmSoundOptionViewControllable {

    weak var listener: CreateAlarmSoundOptionPresentableListener?
    
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    private let mainView = CreateAlarmSoundOptionView()
}

extension CreateAlarmSoundOptionViewController: CreateAlarmSoundOptionViewListener {
    func action(_ action: CreateAlarmSoundOptionView.Action) {
        switch action {
        case let .isVibrateOnChanged(isVabrateOn):
            listener?.request(.isVibrateOnChanged(isVabrateOn))
        case let .isSoundOnChanged(isSoundOn):
            listener?.request(.isSoundOnChanged(isSoundOn))
        case let .volumeChanged(volume):
            listener?.request(.volumeChanged(volume))
        case let .soundSelected(sound):
            listener?.request(.soundSelected(sound))
        case .doneButtonTapped:
            listener?.request(.done)
        }
    }
}
