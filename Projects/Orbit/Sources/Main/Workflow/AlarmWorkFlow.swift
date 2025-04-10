//
//  AlarmWorkFlow.swift
//  Orbit
//
//  Created by ever on 2/11/25.
//

import FeatureMain

import RIBs
import RxSwift

final class AlarmWorkFlow: Workflow<RootActionableItem> {
    init(alarmId: String) {
        super.init()
        
        self
            .onStep { (rootItem: RootActionableItem) -> Observable<(MainPageActionableItem, ())> in
                rootItem.waitFoOnboarding()
            }
            .onStep { (mainPageItem: MainPageActionableItem, _) -> Observable<((MainPageActionableItem, ()))> in
                mainPageItem.showAlarm(alarmId: alarmId)
            }
            .commit()
    }
}
