//
//  PanelAnimationController.swift
//  L3
//
//  Created by Milton Leung on 2019-03-06.
//  Copyright © 2019 ms. All rights reserved.
//

import UIKit

class PanelAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  let duration: TimeInterval
  let operation: UINavigationController.Operation

  init(operation: UINavigationController.Operation, duration: TimeInterval?) {
    self.operation = operation
    self.duration = duration ?? 0.35
  }

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard
      let fromVC = transitionContext.viewController(forKey: .from),
      let toVC = transitionContext.viewController(forKey: .to)
      else { return }

    let containerView = transitionContext.containerView

    let duration = transitionDuration(using: transitionContext)

    func animatePush() {
      let finalFrame = transitionContext.finalFrame(for: toVC)
      toVC.view.frame = finalFrame.offsetBy(dx: finalFrame.width, dy: 0)

      containerView.addSubview(toVC.view)

      UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
        toVC.view.frame = finalFrame
      }, completion: { _ in
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      })
    }

    func animatePop() {
      let startingFrame = transitionContext.initialFrame(for: fromVC)

      containerView.insertSubview(toVC.view, belowSubview: fromVC.view)

      UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
        fromVC.view.frame = startingFrame.offsetBy(dx: startingFrame.width, dy: 0)
      }, completion: { _ in
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      })
    }

    switch operation {
    case .push: animatePush()
    case .pop: animatePop()
    case .none: return
    }
  }
}
