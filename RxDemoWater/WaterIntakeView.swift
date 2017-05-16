//
//  WaterIntakeView.swift
//  RxDemoWater
//
//  Created by Ilian Konchev on 5/15/17.
//  Copyright © 2017 Swift Sofia Meetup. All rights reserved.
//

import UIKit

class WaterIntakeView: UIView {

    var animationDuration: CFTimeInterval = 0.6

    lazy var emptyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "drop")
        imageView.tintColor = UIColor(white: 1.0, alpha: 0.9)
        return imageView

    }()

    lazy var filledImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "drop_filled")
        imageView.tintColor = UIColor(white: 1.0, alpha: 0.9)
        return imageView
    }()

    // MARK: - Mask Layers
    private let filledMask = CAShapeLayer()
    private let emptyMask = CAShapeLayer()

    // MARK: - Animations
    private lazy var emptyImageAnimation: CABasicAnimation = {
        let animation = CABasicAnimation()
        animation.keyPath = "path"
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.isRemovedOnCompletion = false
        return animation
    }()

    private let fillImageAnimation: CABasicAnimation = {
        let animation = CABasicAnimation()
        animation.keyPath = "path"
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.isRemovedOnCompletion = false
        return animation
    }()

    // MARK: - Utility Functions
    private func emptyMaskPath(progress: CGFloat) -> CGPath {
        let maskRect = CGRect(x: 0, y: 0, width: emptyImage.bounds.width, height: emptyImage.bounds.height * (1.0 - progress))
        return CGPath(rect: maskRect, transform: nil)
    }

    private func filledMaskPath(progress: CGFloat) -> CGPath {
        let maskRect = CGRect(x: 0, y: filledImage.bounds.height * (1.0 - progress), width: filledImage.bounds.width, height: filledImage.bounds.height * progress)
        return CGPath(rect: maskRect, transform: nil)
    }

    func setProgress(_ progress: CGFloat, animated: Bool = false) {
        if animated {
            emptyImageAnimation.fromValue = emptyMask.path
            emptyImageAnimation.toValue = emptyMaskPath(progress: progress)
            emptyImageAnimation.duration = animationDuration

            fillImageAnimation.fromValue = filledMask.path
            fillImageAnimation.toValue = filledMaskPath(progress: progress)
            fillImageAnimation.duration = animationDuration

            emptyMask.add(emptyImageAnimation, forKey: nil)
            filledMask.add(fillImageAnimation, forKey: nil)
        }

        emptyMask.path = emptyMaskPath(progress: progress)
        filledMask.path = filledMaskPath(progress: progress)
    }


    // MARK: - UIView
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(emptyImage)
        addSubview(filledImage)

        addConstraints([
            emptyImage.leftAnchor.constraint(equalTo: self.leftAnchor),
            emptyImage.topAnchor.constraint(equalTo:  self.topAnchor),
            emptyImage.widthAnchor.constraint(equalToConstant: self.bounds.size.width),
            emptyImage.heightAnchor.constraint(equalToConstant: self.bounds.size.width),
            filledImage.leftAnchor.constraint(equalTo: self.leftAnchor),
            filledImage.topAnchor.constraint(equalTo:  self.topAnchor),
            filledImage.widthAnchor.constraint(equalToConstant: self.bounds.size.width),
            filledImage.heightAnchor.constraint(equalToConstant: self.bounds.size.height)
        ])

        layoutIfNeeded()
        
        emptyMask.path = emptyMaskPath(progress: 0.0)
        filledMask.path = filledMaskPath(progress: 0.0)

        emptyImage.layer.mask = emptyMask
        filledImage.layer.mask = filledMask


    }

}
