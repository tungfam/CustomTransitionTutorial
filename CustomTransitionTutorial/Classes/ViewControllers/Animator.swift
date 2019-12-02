//
//  Animator.swift
//  CustomTransitionTutorial
//
//  Created by Tung on 27.11.19.
//  Copyright © 2019 Tung. All rights reserved.
//

import UIKit

// 8
final class Animator: NSObject, UIViewControllerAnimatedTransitioning {

    // 9

    static let duration: TimeInterval = 1.25

    private let type: PresentationType
    private let firstViewController: FirstViewController
    private let secondViewController: SecondViewController
    private let selectedCellImageViewSnapshot: UIView
    private let cellImageViewRect: CGRect

    // 10
    init?(type: PresentationType, firstViewController: FirstViewController, secondViewController: SecondViewController, selectedCellImageViewSnapshot: UIView) {
        self.type = type
        self.firstViewController = firstViewController
        self.secondViewController = secondViewController
        self.selectedCellImageViewSnapshot = selectedCellImageViewSnapshot

        guard let window = firstViewController.view.window ?? secondViewController.view.window,
            let selectedCell = firstViewController.selectedCell
            else { return nil }

        // 11
        self.cellImageViewRect = selectedCell.locationImageView.convert(selectedCell.locationImageView.bounds, to: window)
    }

    // 12
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Self.duration
    }

    // 13
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 18
        let containerView = transitionContext.containerView

        // 19
        guard let toView = secondViewController.view
            else {
                transitionContext.completeTransition(false)
                return
        }

        containerView.addSubview(toView)

        // 21
        guard let selectedCell = firstViewController.selectedCell,
            let window = firstViewController.view.window ?? secondViewController.view.window,
            let cellImageSnapshot = selectedCell.locationImageView.snapshotView(afterScreenUpdates: true),
            let controllerImageSnapshot = secondViewController.locationImageView.snapshotView(afterScreenUpdates: true)
            else {
                transitionContext.completeTransition(true)
                return
        }

        let isPresenting = type.isPresenting

        // 22
        let imageViewSnapshot: UIView

        if isPresenting {
            imageViewSnapshot = cellImageSnapshot
        } else {
            imageViewSnapshot = controllerImageSnapshot
        }

        // 23
        toView.alpha = 0

        // 24
        [imageViewSnapshot].forEach { containerView.addSubview($0) }

        // 25
        let controllerImageViewRect = secondViewController.locationImageView.convert(secondViewController.locationImageView.bounds, to: window)

        // 26
        [imageViewSnapshot].forEach {
            $0.frame = isPresenting ? cellImageViewRect : controllerImageViewRect
        }

        // 27
        UIView.animateKeyframes(withDuration: Self.duration, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                // 28
                imageViewSnapshot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect
            }
        }, completion: { _ in
            // 29
            imageViewSnapshot.removeFromSuperview()

            // 30
            toView.alpha = 1

            // 31
            transitionContext.completeTransition(true)
        })
    }
}

// 14
enum PresentationType {

    case present
    case dismiss

    var isPresenting: Bool {
        return self == .present
    }
}
