//
//  CreateAlarmSoundOptionBuilder.swift
//  FeatureAlarm
//
//  Created by ever on 1/26/25.
//

import RIBs

protocol CreateAlarmSoundOptionDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class CreateAlarmSoundOptionComponent: Component<CreateAlarmSoundOptionDependency> {
    fileprivate let isVibrateOn: Bool
    fileprivate let isSoundOn: Bool
    fileprivate let volume: Float
    fileprivate let selectedSound: String?
    
    init(dependency: CreateAlarmSoundOptionDependency, isVibrateOn: Bool, isSoundOn: Bool, volume: Float, selectedSound: String?) {
        self.isVibrateOn = isVibrateOn
        self.isSoundOn = isSoundOn
        self.volume = volume
        self.selectedSound = selectedSound
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol CreateAlarmSoundOptionBuildable: Buildable {
    func build(
        withListener listener: CreateAlarmSoundOptionListener,
        isVibrateOn: Bool,
        isSoundOn: Bool,
        volume: Float,
        selectedSound: String?
    ) -> CreateAlarmSoundOptionRouting
}

final class CreateAlarmSoundOptionBuilder: Builder<CreateAlarmSoundOptionDependency>, CreateAlarmSoundOptionBuildable {

    override init(dependency: CreateAlarmSoundOptionDependency) {
        super.init(dependency: dependency)
    }

    func build(
        withListener listener: CreateAlarmSoundOptionListener,
        isVibrateOn: Bool,
        isSoundOn: Bool,
        volume: Float,
        selectedSound: String?
    ) -> CreateAlarmSoundOptionRouting {
        let component = CreateAlarmSoundOptionComponent(
            dependency: dependency,
            isVibrateOn: isVibrateOn,
            isSoundOn: isSoundOn,
            volume: volume,
            selectedSound: selectedSound
        )
        let viewController = CreateAlarmSoundOptionViewController()
        let interactor = CreateAlarmSoundOptionInteractor(
            presenter: viewController,
            isVibrateOn: component.isVibrateOn,
            isSoundOn: component.isSoundOn,
            volume: component.volume,
            selectedSound: component.selectedSound
        )
        interactor.listener = listener
        return CreateAlarmSoundOptionRouter(interactor: interactor, viewController: viewController)
    }
}
