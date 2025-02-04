//
//  CreateAlarmSoundOptionInteractor.swift
//  FeatureAlarm
//
//  Created by ever on 1/26/25.
//

import RIBs
import RxSwift
import AVFoundation
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
        service: CreateAlarmSoundOptionServiceable,
        soundOption: SoundOption
    ) {
        self.service = service
        self.soundOption = soundOption
        super.init(presenter: presenter)
        presenter.listener = self
    }

    private let service: CreateAlarmSoundOptionServiceable
    private var soundOption: SoundOption
    
    func request(_ request: CreateAlarmSoundOptionPresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            presenter.request(.updateOption(soundOption))
        case let .isVibrateOnChanged(isVibrateOn):
            soundOption.isVibrationOn = isVibrateOn
            if isVibrateOn {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            }
            presenter.request(.updateOption(soundOption))
        case let .isSoundOnChanged(isSoundOn):
            soundOption.isSoundOn = isSoundOn
            if isSoundOn == false {
                service.stopSound()
            }
            presenter.request(.updateOption(soundOption))
        case let .volumeChanged(volume):
            soundOption.volume = volume
            service.playSound(with: soundOption)
            presenter.request(.updateOption(soundOption))
        case let .soundSelected(sound):
            soundOption.selectedSound = sound
            service.playSound(with: soundOption)
            presenter.request(.updateOption(soundOption))
        case .done:
            service.stopSound()
            listener?.request(.done(soundOption))
        }
    }
}
