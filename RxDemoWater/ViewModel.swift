//
//  ViewModel.swift
//  RxDemoWater
//
//  Created by Ilian Konchev on 5/15/17.
//  Copyright © 2017 Swift Sofia Meetup. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel {

    let animationDuration: CFTimeInterval = 0.6
    let intakeGoal = Variable<Int>(8)
    let currentIntake = Variable<Int>(1)
    let disposeBag = DisposeBag()

    func addWater() {
        currentIntake.value = min(intakeGoal.value, currentIntake.value + 1)
    }

    func takeWater() {
        currentIntake.value = max(1, currentIntake.value - 1)
    }

    func startTakingWater() {
        Observable<Int>.interval(RxTimeInterval(5.0), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .subscribe(onNext: { [weak self] interval in
                self?.takeWater()
            })
            .disposed(by: disposeBag)
    }

}
