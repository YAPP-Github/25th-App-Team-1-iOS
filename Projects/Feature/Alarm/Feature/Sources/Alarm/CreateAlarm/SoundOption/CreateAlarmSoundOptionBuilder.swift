//
//  CreateAlarmSoundOptionBuilder.swift
//  FeatureAlarm
//
//  Created by ever on 1/26/25.
//

import RIBs
import FeatureResources
import FeatureCommonDependencies

protocol CreateAlarmSoundOptionDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class CreateAlarmSoundOptionComponent: Component<CreateAlarmSoundOptionDependency> {
    fileprivate let soundOption: SoundOption
    
    init(dependency: CreateAlarmSoundOptionDependency, soundOption: SoundOption) {
        self.soundOption = soundOption
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol CreateAlarmSoundOptionBuildable: Buildable {
    func build(withListener listener: CreateAlarmSoundOptionListener, soundOption: SoundOption) -> CreateAlarmSoundOptionRouting
}

final class CreateAlarmSoundOptionBuilder: Builder<CreateAlarmSoundOptionDependency>, CreateAlarmSoundOptionBuildable {

    override init(dependency: CreateAlarmSoundOptionDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CreateAlarmSoundOptionListener, soundOption: SoundOption) -> CreateAlarmSoundOptionRouting {
        let component = CreateAlarmSoundOptionComponent(dependency: dependency, soundOption: soundOption)
        let viewController = CreateAlarmSoundOptionViewController()
        let interactor = CreateAlarmSoundOptionInteractor(presenter: viewController, soundOption: soundOption)
        interactor.listener = listener
        return CreateAlarmSoundOptionRouter(interactor: interactor, viewController: viewController)
    }
}
