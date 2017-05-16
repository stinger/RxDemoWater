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
    let intakeProgress = Variable<CGFloat>(0.0)
    let disposeBag = DisposeBag()

    func addWater() {
        if intakeProgress.value < 1.0 {
            intakeProgress.value = min(1.0, intakeProgress.value + 0.2)
        }
    }

    func takeWater() {
        if intakeProgress.value > 0.0 {
            intakeProgress.value = max(0.0, intakeProgress.value - 0.2)
        }
    }

    func startTakingWater() {
        Observable<Int>.interval(RxTimeInterval(5.0), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .subscribe(onNext: { [weak self] interval in
                self?.takeWater()
            })
            .disposed(by: disposeBag)
    }

}
