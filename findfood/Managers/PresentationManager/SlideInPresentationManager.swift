//
//  SlidePresentationManager.swift
//  findfood
//
//  Created by Bertay Yönel on 31.03.2023.
//

import UIKit

// MARK: - SlideInPresentationManager
final class SlideInPresentationManager: NSObject {
    var direction: PresentationDirection = .left
}
// MARK: - SlideInPresentationManager Extension for UIViewControllerTransitioningDelegate
extension SlideInPresentationManager: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = SlideInPresentationController(presentedViewController: presented, presentingViewController: presenting, direction: direction)
        return presentationController
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        SlideInPresentationAnimator(isPresentation: false, direction: direction)
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        SlideInPresentationAnimator(isPresentation: true, direction: direction)
    }
}
