//
//  OnboardingModel.swift
//  FeatureOnboarding
//
//  Created by ever on 1/14/25.
//

import Foundation
import FeatureCommonDependencies

public struct OnboardingModel {
    var alarm: Alarm?
    var birthDate: BirthDateData?
    var bornTime: BornTimeData?
    var name: String?
    var gender: Gender?
}
