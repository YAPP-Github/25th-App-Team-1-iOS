//
//  CreateAlarmSoundOptionInteractor.swift
//  FeatureAlarm
//
//  Created by ever on 1/26/25.
//

import RIBs
import RxSwift
import FeatureResources
import FeatureCommonDependencies

protocol CreateAlarmSoundOptionRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

enum CreateAlarmSoundOptionPresentableRequest {
    case updateOption(SoundOption)
}

protocol CreateAlarmSoundOptionPresentable: Presentable {
    var listener: CreateAlarmSoundOptionPresentableListener? { get set }
    func request(_ request: CreateAlarmSoundOptionPresentableRequest)
}

enum CreateAlarmSoundOptionListenerRequest {
    case done(SoundOption)
}

protocol CreateAlarmSoundOptionListener: AnyObject {
    func request(_ request: CreateAlarmSoundOptionListenerRequest)
}

final class CreateAlarmSoundOptionInteractor: PresentableInteractor<CreateAlarmSoundOptionPresentable>, CreateAlarmSoundOptionInteractable, CreateAlarmSoundOptionPresentableListener {

    weak var router: CreateAlarmSoundOptionRouting?
    weak var listener: CreateAlarmSoundOptionListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: CreateAlarmSoundOptionPresentable,
        soundOption: SoundOption
    ) {
        self.soundOption = soundOption
        super.init(presenter: presenter)
        presenter.listener = self
    }

    private var soundOption: SoundOption
    
    func request(_ request: CreateAlarmSoundOptionPresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            presenter.request(.updateOption(soundOption))
        case let .isVibrateOnChanged(isVibrateOn):
            soundOption.isVibrationOn = isVibrateOn
            presenter.request(.updateOption(soundOption))
        case let .isSoundOnChanged(isSoundOn):
            soundOption.isSoundOn = isSoundOn
            presenter.request(.updateOption(soundOption))
        case let .volumeChanged(volume):
            soundOption.volume = volume
            presenter.request(.updateOption(soundOption))
        case let .soundSelected(sound):
            soundOption.selectedSound = sound
            presenter.request(.updateOption(soundOption))
        case .done:
            listener?.request(.done(soundOption))
        }
    }
}
