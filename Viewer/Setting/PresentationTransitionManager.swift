//
//  PresentationTransitionManager.swift
//  Viewer
//
//  Created by bl4ckra1sond3tre on 3/9/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import UIKit

class PresentationTransitionManager: NSObject {
    var duration: NSTimeInterval = 0.4
    
    enum TransitionType {
        case Present, Dismiss
    }
    
    var transitionType: TransitionType?
}

extension PresentationTransitionManager: UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if transitionType == .Present {
            animatePresentWithTransition(transitionContext)
        } else {
            animateDismissWithTransition(transitionContext)
        }
    }
    
    private func animatePresentWithTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView(),
            toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
            else {
                return
        }
        
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        containerView.addSubview(toViewController.view)
        let finalFrame = transitionContext.finalFrameForViewController(toViewController)

        toViewController.view.frame = finalFrame
        toViewController.view.center.y += containerView.bounds.height
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.66, initialSpringVelocity: 0.0, options: .AllowUserInteraction, animations: { () -> Void in
            toViewController.view.frame = finalFrame
            toViewController.view.center.y += 66
            
            fromViewController?.view.transform = CGAffineTransformMakeScale(0.88, 0.88)
            }) { (finished) -> Void in
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
    
    private func animateDismissWithTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView(),
            fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
            else {
                return
        }
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            fromViewController.view.center.y += containerView.bounds.height
            toViewController?.view.transform = CGAffineTransformIdentity
            
            }) { (finished) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}

extension PresentationTransitionManager: UIViewControllerTransitioningDelegate {
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionType = .Present
        
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionType = .Dismiss
        
        return self
    }
}

