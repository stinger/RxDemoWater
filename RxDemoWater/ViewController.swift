//
//  ViewController.swift
//  RxDemoWater
//
//  Created by Ilian Konchev on 5/15/17.
//  Copyright © 2017 Swift Sofia Meetup. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var intakeView: WaterIntakeView!
    @IBOutlet weak var addWaterButton: UIButton!

    // MARK: - Rx
    let viewModel = ViewModel()
    let disposeBag = DisposeBag()

    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        decorateAddDataButton()
        setupDataObservers()
        setupInteractions()
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        viewModel.currentIntake.accept(1)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    // MARK: - Utility Methods
    private func decorateAddDataButton() {
        addWaterButton.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).cgColor
        addWaterButton.layer.borderWidth = 1.0
        addWaterButton.layer.cornerRadius = 4.0
    }

    private func setupDataObservers() {
        Observable.combineLatest(viewModel.intakeGoal.asObservable(), viewModel.currentIntake.asObservable())
            .filter { $1 > 0 }
            .map { goal, intake in
                return max(0.0, min(1.0, (CGFloat(intake) / CGFloat(goal))))
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] progress in
                self?.intakeView.setProgress(progress, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func setupInteractions() {
        addWaterButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.viewModel.addWater()
            })
            .disposed(by: disposeBag)

        viewModel.startTakingWater()
            .disposed(by: disposeBag)
    }
}

