//
//  ViewModel.swift
//  RxDemoWater
//
//  Created by Ilian Konchev on 5/15/17.
//  Copyright © 2017 Swift Sofia Meetup. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class ViewModel {

    let animationDuration: CFTimeInterval = 0.6
    let intakeGoal = BehaviorRelay<Int>(value: 8)
    let currentIntake = BehaviorRelay<Int>(value: 1)

    func addWater() {
        currentIntake.accept(min(intakeGoal.value, currentIntake.value + 1))
    }

    func takeWater() {
        currentIntake.accept(max(1, currentIntake.value - 1))
    }

    func startTakingWater() -> Disposable {
        return Observable<Int>.interval(DispatchTimeInterval.seconds(5), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .subscribe(onNext: { [weak self] interval in
                self?.takeWater()
            })

    }

}
