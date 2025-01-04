//
//  AppComponent.swift
//  Orbit
//
//  Created by 손병근 on 1/4/25.
//

import RIBs

class AppComponent: Component<EmptyDependency>, MainDependency {
    init() {
        super.init(dependency: EmptyComponent())
    }
}
