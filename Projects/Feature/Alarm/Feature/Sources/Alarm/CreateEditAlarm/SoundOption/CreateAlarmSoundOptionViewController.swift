//
//  CreateEditAlarmSoundOptionViewController.swift
//  FeatureAlarm
//
//  Created by ever on 1/26/25.
//

import RIBs
import RxSwift
import UIKit
import FeatureResources

enum CreateEditAlarmSoundOptionPresentableListenerRequest {
    case viewDidLoad
    case isVibrateOnChanged(Bool)
    case isSoundOnChanged(Bool)
    case volumeChanged(Float)
    case soundSelected(String)
    case done
}
protocol CreateEditAlarmSoundOptionPresentableListener: AnyObject {
    func request(_ request: CreateEditAlarmSoundOptionPresentableListenerRequest)
}

final class CreateEditAlarmSoundOptionViewController: UIViewController, CreateEditAlarmSoundOptionPresentable, CreateEditAlarmSoundOptionViewControllable {

    weak var listener: CreateEditAlarmSoundOptionPresentableListener?
    
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listener?.request(.viewDidLoad)
    }
    
    func request(_ request: CreateEditAlarmSoundOptionPresentableRequest) {
        switch request {
        case let .updateOption(option):
            mainView.updateOption(option: option)
        }
    }
    
    private let mainView = CreateEditAlarmSoundOptionView()
}

extension CreateEditAlarmSoundOptionViewController: CreateEditAlarmSoundOptionViewListener {
    func action(_ action: CreateEditAlarmSoundOptionView.Action) {
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
