//
//  PresentationController.swift
//  findfood
//
//  Created by Bertay Yönel on 6.06.2023.
//

import UIKit
// MARK: - SlideInPresentationController
class SlideInPresentationController: UIPresentationController {
    // MARK: Properties
    private var direction: PresentationDirection
    private var dimmingView: UIView!
    // MARK: init
    init(presentedViewController: UIViewController, presentingViewController: UIViewController?, direction: PresentationDirection) {
        self.direction = direction
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }
    // MARK: Functions
    /// Prepares for the beginning of a transition.
    override func presentationTransitionWillBegin() {
        guard let dimmingView = dimmingView else {
            return
        }
        containerView?.insertSubview(dimmingView, at: 0)
        dimmingView.setConstraint(
            top: containerView?.topAnchor,
            leading: containerView?.leadingAnchor,
            bottom: containerView?.bottomAnchor,
            trailing: containerView?.trailingAnchor,
            topConstraint: .zero,
            leadingConstraint: .zero,
            bottomConstraint: .zero,
            trailingConstraint: .zero
        )
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    /// Prepares for the dismissal of a transition.
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        switch direction {
          case .left, .right:
            return CGSize(width: parentSize.width*(2.0/3.0), height: parentSize.height)
          case .bottom, .top:
            return CGSize(width: parentSize.width, height: parentSize.height*(2.0/3.0))
          }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerView!.bounds.size)
        switch direction {
        case .right:
          frame.origin.x = containerView!.frame.width*(1.0/3.0)
        case .bottom:
          frame.origin.y = containerView!.frame.height*(1.0/3.0)
        default:
          frame.origin = .zero
        }
        return frame
    }
}

private extension SlideInPresentationController {
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(recognizer)
    }
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true)
    }
}
