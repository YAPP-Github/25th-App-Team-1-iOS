//
//  MainInteractor.swift
//  Orbit
//
//  Created by 손병근 on 1/4/25.
//

import Foundation
import RIBs
import RxSwift
import RxRelay
import FeatureOnboarding
import FeatureCommonDependencies
import FeatureResources
import FeatureMain
import UserNotifications

protocol RootActionableItem: AnyObject {
    func waitFoOnboarding() -> Observable<(MainPageActionableItem, ())>
}

protocol AlarmIdHandler: AnyObject {
    func handle(_ alarmId: String)
}

enum MainRouterRequest {
    case routeToOnboarding
    case detachOnboarding
    case routeToMain(((MainPageActionableItem) -> Void)?)
    case detachMain
}

protocol MainRouting: ViewableRouting {
    func request(_ request: MainRouterRequest)
}

protocol MainPresentable: Presentable {
    var listener: MainPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MainListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MainInteractor: PresentableInteractor<MainPresentable>, MainInteractable, MainPresentableListener {

    weak var router: MainRouting?
    weak var listener: MainListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: MainPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        if Preference.isOnboardingFinished {
            router?.request(.routeToMain { [weak self] actionableItem in
                self?.mainPageActionableItemSubject.onNext(actionableItem)
            })
        } else {
            router?.request(.routeToOnboarding)
        }
    }
    
    private let mainPageActionableItemSubject = ReplaySubject<MainPageActionableItem>.create(bufferSize: 1)
    
    private func scheduleNotification(for alarm: Alarm) {
        let center = UNUserNotificationCenter.current()
        
        // 알림 콘텐츠 구성
        let content = UNMutableNotificationContent()
        content.title = "알람"
        content.body = "설정한 알람 시간입니다."
        content.userInfo = ["alarmId": alarm.id]

        // 알림 트리거 구성
        let dateComponents = alarm.nextDateComponents()
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let identifier = alarm.id
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("알림 스케줄링 오류: \(error.localizedDescription)")
            } else {
                print("알림이 성공적으로 스케줄되었습니다. 식별자: \(identifier)")
            }
        }
    }
    
    private func scheduleTimer(with alarm: Alarm, soundUrl: URL) {
        AlarmManager.shared.activateSession()
        let calendar = Calendar.current
        guard let date = calendar.date(from: alarm.nextDateComponents()) else { return }
        let currentDate = Date()
        let timeInterval = date.timeIntervalSince(currentDate)
        print(timeInterval)
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
            VolumeManager.setVolume(alarm.soundOption.volume) // 설정한 볼륨값 0.0~1.0으로 설정
            AlarmManager.shared.playAlarmSound(with: soundUrl, volume: alarm.soundOption.volume)
        }

    }
}

// MARK: OnboardRootListenerRequest
extension MainInteractor {
    func request(_ request: RootListenerRequest) {
        switch request {
        case let .start(alarm):
            router?.request(.detachOnboarding)
            AlarmStore.shared.add(alarm)
            guard let soundUrl = R.AlarmSound.allCases.first(where: { $0.title == alarm.soundOption.selectedSound })?.alarm else { return }
            scheduleNotification(for: alarm)
            scheduleTimer(with: alarm, soundUrl: soundUrl)
            router?.request(.routeToMain { [weak self] actionableItem in
                self?.mainPageActionableItemSubject.onNext(actionableItem)
            })
        }
    }
}

extension MainInteractor: AlarmIdHandler {
    func handle(_ alarmId: String) {
        let alarmWorkFlow = AlarmWorkFlow(alarmId: alarmId)
        alarmWorkFlow
            .subscribe(self)
            .disposeOnDeactivate(interactor: self)
    }
}

extension MainInteractor: RootActionableItem {
    func waitFoOnboarding() -> Observable<(MainPageActionableItem, ())> {
        return mainPageActionableItemSubject
            .map { (mainPageItem: MainPageActionableItem) -> (MainPageActionableItem, ()) in
                    (mainPageItem, ())
                }
    }
}
