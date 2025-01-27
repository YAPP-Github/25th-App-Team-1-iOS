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

protocol CreateAlarmSoundOptionPresentable: Presentable {
    var listener: CreateAlarmSoundOptionPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol CreateAlarmSoundOptionListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
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
        case let .isVibrateOnChanged(isVibrateOn):
            self.isVibrateOn = isVibrateOn
        case let .isSoundOnChanged(isSoundOn):
            self.isSoundOn = isSoundOn
        case let .volumeChanged(volume):
            self.volume = volume
        case let .soundSelected(sound):
            self.selectedSound = sound
        case .done:
            print("isVibrateOn: \(isVibrateOn)\nisSoundOn: \(isSoundOn)\nvolume: \(volume)\nselectedSound: \(selectedSound ?? "none")")
        }
    }
}
