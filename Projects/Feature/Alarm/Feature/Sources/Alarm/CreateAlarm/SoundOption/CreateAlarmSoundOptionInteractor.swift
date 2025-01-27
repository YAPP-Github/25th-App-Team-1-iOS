//
//  CreateAlarmSoundOptionInteractor.swift
//  FeatureAlarm
//
//  Created by ever on 1/26/25.
//

import RIBs
import RxSwift

protocol CreateAlarmSoundOptionRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

enum CreateAlarmSoundOptionPresentableRequest {
    case disableAlarmSound
    case setOptions(volume: Float, selectedSound: String?)
}

protocol CreateAlarmSoundOptionPresentable: Presentable {
    var listener: CreateAlarmSoundOptionPresentableListener? { get set }
    func request(_ request: CreateAlarmSoundOptionPresentableRequest)
}

enum CreateAlarmSoundOptionListenerRequest {
    case done
}

protocol CreateAlarmSoundOptionListener: AnyObject {
    func request(_ request: CreateAlarmSoundOptionListenerRequest)
}

final class CreateAlarmSoundOptionInteractor: PresentableInteractor<CreateAlarmSoundOptionPresentable>, CreateAlarmSoundOptionInteractable, CreateAlarmSoundOptionPresentableListener {

    weak var router: CreateAlarmSoundOptionRouting?
    weak var listener: CreateAlarmSoundOptionListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: CreateAlarmSoundOptionPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    private var isVibrateOn: Bool = true
    private var isSoundOn: Bool = true
    private var volume: Float = 0.7
    private var selectedSound: String?
    
    func request(_ request: CreateAlarmSoundOptionPresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            presenter.request(.setOptions(volume: volume, selectedSound: selectedSound))
        case let .isVibrateOnChanged(isVibrateOn):
            self.isVibrateOn = isVibrateOn
        case let .isSoundOnChanged(isSoundOn):
            self.isSoundOn = isSoundOn
            if isSoundOn {
                presenter.request(.setOptions(volume: volume, selectedSound: selectedSound))
            } else {
                presenter.request(.disableAlarmSound)
            }
        case let .volumeChanged(volume):
            self.volume = volume
        case let .soundSelected(sound):
            self.selectedSound = sound
        case .done:
            print("isVibrateOn: \(isVibrateOn)\nisSoundOn: \(isSoundOn)\nvolume: \(volume)\nselectedSound: \(selectedSound ?? "none")")
            listener?.request(.done)
        }
    }
}
