//
//  AlarmReleaseIntroBuilder.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/10/25.
//

import UIKit

import FeatureCommonDependencies
import FeatureAlarmController
import FeatureLogger
import FeatureAlarmMission
import FeatureFortune

import RIBs

protocol AlarmReleaseIntroDependency: Dependency {
    var alarm: Alarm { get }
    var isFirstAlarm: Bool { get }
    var alarmController: AlarmController { get }
    var releaseAlarmStream: ReleaseAlarmStream { get }
    var logger: Logger { get }
}

final class AlarmReleaseIntroComponent: Component<AlarmReleaseIntroDependency> {
    var logger: Logger { dependency.logger }
}

// MARK: - Builder

public protocol AlarmReleaseIntroBuildable: Buildable {
    func build(withListener listener: AlarmReleaseIntroListener) -> AlarmReleaseIntroRouting
}

final class AlarmReleaseIntroBuilder: Builder<AlarmReleaseIntroDependency>, AlarmReleaseIntroBuildable {

    override init(dependency: AlarmReleaseIntroDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AlarmReleaseIntroListener) -> AlarmReleaseIntroRouting {
        let component = AlarmReleaseIntroComponent(dependency: dependency)
        let viewController = AlarmReleaseIntroViewController()
        let interactor = AlarmReleaseIntroInteractor(
            presenter: viewController,
            alarm: dependency.alarm,
            isFirstAlarm: dependency.isFirstAlarm,
            alarmController: dependency.alarmController,
            stream: dependency.releaseAlarmStream,
            logger: dependency.logger
        )
        interactor.listener = listener

        return AlarmReleaseIntroRouter(
            interactor: interactor,
            viewController: viewController
        )
    }
}
