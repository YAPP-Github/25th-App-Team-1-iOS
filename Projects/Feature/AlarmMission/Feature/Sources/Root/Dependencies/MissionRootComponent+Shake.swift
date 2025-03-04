//
//  MissionRootComponent+Shake.swift
//  AlarmMission
//
//  Created by choijunios on 3/4/25.
//

import RxRelay

extension MissionRootComponent: ShakeMissionMainDependency {
    var action: PublishRelay<MissionState> { self.missionAction }
}
