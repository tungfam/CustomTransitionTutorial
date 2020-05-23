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
    private var selectedCellImageViewSnapshot: UIView
    private let cellImageViewRect: CGRect

    // 45
    private let cellLabelRect: CGRect

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

        // 46
        self.cellLabelRect = selectedCell.locationLabel.convert(selectedCell.locationLabel.bounds, to: window)
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
        guard
            let selectedCell = firstViewController.selectedCell,
            let window = firstViewController.view.window ?? secondViewController.view.window,
            let cellImageSnapshot = selectedCell.locationImageView.snapshotView(afterScreenUpdates: true),
            let controllerImageSnapshot = secondViewController.locationImageView.snapshotView(afterScreenUpdates: true),
            let cellLabelSnapshot = selectedCell.locationLabel.snapshotView(afterScreenUpdates: true), // 47
            let closeButtonSnapshot = secondViewController.closeButton.snapshotView(afterScreenUpdates: true) // 53
            else {
                transitionContext.completeTransition(true)
                return
        }

        let isPresenting = type.isPresenting

        // 40
        let backgroundView: UIView
        let fadeView = UIView(frame: containerView.bounds)
        fadeView.backgroundColor = secondViewController.view.backgroundColor

        // 33
        if isPresenting {
            selectedCellImageViewSnapshot = cellImageSnapshot
            
            selectedCell.alpha = 0

            // 41
            backgroundView = UIView(frame: containerView.bounds)
            backgroundView.addSubview(fadeView)
            fadeView.alpha = 0
        } else {
            backgroundView = firstViewController.view.snapshotView(afterScreenUpdates: true) ?? fadeView
            backgroundView.addSubview(fadeView)
            selectedCell.alpha = 1
        }

        // 23
        toView.alpha = 0

        // 34
        // 42
        // 48
        // 54
        [backgroundView, selectedCellImageViewSnapshot, controllerImageSnapshot, cellLabelSnapshot, closeButtonSnapshot].forEach { containerView.addSubview($0) }

        // 25
        let controllerImageViewRect = secondViewController.locationImageView.convert(secondViewController.locationImageView.bounds, to: window)
        // 49
        let controllerLabelRect = secondViewController.locationLabel.convert(secondViewController.locationLabel.bounds, to: window)
        // 55
        let closeButtonRect = secondViewController.closeButton.convert(secondViewController.closeButton.bounds, to: window)

        // 35
        [selectedCellImageViewSnapshot, controllerImageSnapshot].forEach {
            $0.frame = isPresenting ? cellImageViewRect : controllerImageViewRect

            // 59
            $0.layer.cornerRadius = isPresenting ? 12 : 0
            $0.layer.masksToBounds = true
        }

        // 36
        controllerImageSnapshot.alpha = isPresenting ? 0 : 1

        // 37
        selectedCellImageViewSnapshot.alpha = isPresenting ? 1 : 0

        // 50
        cellLabelSnapshot.frame = isPresenting ? cellLabelRect : controllerLabelRect

        // 56
        closeButtonSnapshot.frame = closeButtonRect
        closeButtonSnapshot.alpha = isPresenting ? 0 : 1

        // 27
        UIView.animateKeyframes(withDuration: Self.duration, delay: 0, options: .calculationModeCubic, animations: {

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                // 38
                self.selectedCellImageViewSnapshot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect
                controllerImageSnapshot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect

                // 43
                fadeView.alpha = isPresenting ? 1 : 0

                // 51
                cellLabelSnapshot.frame = isPresenting ? controllerLabelRect : self.cellLabelRect

                // 60
                [controllerImageSnapshot, self.selectedCellImageViewSnapshot].forEach {
                    $0.layer.cornerRadius = isPresenting ? 0 : 12
                }
            }

            // 39
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6) {
                self.selectedCellImageViewSnapshot.alpha = isPresenting ? 0 : 1
                controllerImageSnapshot.alpha = isPresenting ? 1 : 0
            }

            // 57
            UIView.addKeyframe(withRelativeStartTime: isPresenting ? 0.7 : 0, relativeDuration: 0.3) {
                closeButtonSnapshot.alpha = isPresenting ? 1 : 0
            }
        }, completion: { _ in
            // 29
            self.selectedCellImageViewSnapshot.removeFromSuperview()
            controllerImageSnapshot.removeFromSuperview()

            // 44
            backgroundView.removeFromSuperview()
            // 52
            cellLabelSnapshot.removeFromSuperview()
            // 58
            closeButtonSnapshot.removeFromSuperview()

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
