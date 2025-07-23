//
//  MissionPreviewViewController.swift
//  FeatureConfigureMissionForAlarm
//
//  Created by choijunios on 7/23/25.
//

import RIBs
import RxSwift
import UIKit

protocol MissionPreviewPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class MissionPreviewViewController: UIViewController, MissionPreviewPresentable, MissionPreviewViewControllable {

    weak var listener: MissionPreviewPresentableListener?
}
