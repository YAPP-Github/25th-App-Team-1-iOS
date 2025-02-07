//
//  CreateEditAlarmSoundOptionInteractor.swift
//  FeatureAlarm
//
//  Created by ever on 1/26/25.
//

import RIBs
import RxSwift
import AVFoundation
import FeatureResources
import FeatureCommonDependencies

protocol CreateEditAlarmSoundOptionRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

enum CreateEditAlarmSoundOptionPresentableRequest {
    case updateOption(SoundOption)
}

protocol CreateEditAlarmSoundOptionPresentable: Presentable {
    var listener: CreateEditAlarmSoundOptionPresentableListener? { get set }
    func request(_ request: CreateEditAlarmSoundOptionPresentableRequest)
}

enum CreateEditAlarmSoundOptionListenerRequest {
    case done(SoundOption)
}

protocol CreateEditAlarmSoundOptionListener: AnyObject {
    func request(_ request: CreateEditAlarmSoundOptionListenerRequest)
}

final class CreateEditAlarmSoundOptionInteractor: PresentableInteractor<CreateEditAlarmSoundOptionPresentable>, CreateEditAlarmSoundOptionInteractable, CreateEditAlarmSoundOptionPresentableListener {

    weak var router: CreateEditAlarmSoundOptionRouting?
    weak var listener: CreateEditAlarmSoundOptionListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: CreateEditAlarmSoundOptionPresentable,
        service: CreateEditAlarmSoundOptionServiceable,
        soundOption: SoundOption
    ) {
        self.service = service
        self.soundOption = soundOption
        super.init(presenter: presenter)
        presenter.listener = self
    }

    private let service: CreateEditAlarmSoundOptionServiceable
    private var soundOption: SoundOption
    
    func request(_ request: CreateEditAlarmSoundOptionPresentableListenerRequest) {
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
