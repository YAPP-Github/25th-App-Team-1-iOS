//
//  CreateEditAlarmSoundOptionBuilder.swift
//  FeatureAlarm
//
//  Created by ever on 1/26/25.
//

import RIBs
import FeatureResources
import FeatureCommonDependencies

protocol CreateEditAlarmSoundOptionDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class CreateEditAlarmSoundOptionComponent: Component<CreateEditAlarmSoundOptionDependency> {
    fileprivate let soundOption: SoundOption
    fileprivate let service: CreateEditAlarmSoundOptionServiceable
    
    init(dependency: CreateEditAlarmSoundOptionDependency, soundOption: SoundOption, service: CreateEditAlarmSoundOptionServiceable = CreateEditAlarmSoundOptionService()) {
        self.soundOption = soundOption
        self.service = service
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol CreateEditAlarmSoundOptionBuildable: Buildable {
    func build(withListener listener: CreateEditAlarmSoundOptionListener, soundOption: SoundOption) -> CreateEditAlarmSoundOptionRouting
}

final class CreateEditAlarmSoundOptionBuilder: Builder<CreateEditAlarmSoundOptionDependency>, CreateEditAlarmSoundOptionBuildable {

    override init(dependency: CreateEditAlarmSoundOptionDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CreateEditAlarmSoundOptionListener, soundOption: SoundOption) -> CreateEditAlarmSoundOptionRouting {
        let component = CreateEditAlarmSoundOptionComponent(dependency: dependency, soundOption: soundOption)
        let viewController = CreateEditAlarmSoundOptionViewController()
        let interactor = CreateEditAlarmSoundOptionInteractor(presenter: viewController, service: component.service, soundOption: soundOption)
        interactor.listener = listener
        return CreateEditAlarmSoundOptionRouter(interactor: interactor, viewController: viewController)
    }
}
