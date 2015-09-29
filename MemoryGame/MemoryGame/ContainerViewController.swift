//
//  ContainerViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    var centerNavigationController: UINavigationController!
    var centerViewController: menuViewController!
    
    var currentState: SlideOutState = .collapsed {
        didSet {
            let shouldShowShadow = currentState != .collapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    var optionsViewController: optionsTableViewController?
    
    let expandedScreenRatio = 4.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    centerViewController = UIStoryboard.centerViewController()
    centerViewController.delegate = self
    
    // wrap the centerViewController in a navigation controller, so we can push views to it
    // and display bar button items in the navigation bar
    centerNavigationController = UINavigationController(rootViewController: centerViewController)
    centerNavigationController.navigationBar.hidden = true
    view.addSubview(centerNavigationController.view)
    addChildViewController(centerNavigationController)
    
    centerNavigationController.didMoveToParentViewController(self)
    
    let panGestureRecognizer:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
    centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
  }
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
  
}

// MARK: CenterViewController delegate

extension ContainerViewController: MenuViewControllerDelegate {
    
    func toggleOptionsPanel() {
        let notAlreadyExpanded = (currentState != .expanded)
        
        if notAlreadyExpanded {
            addOptionsViewController()
        }
        
        animateOptionsPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func collapseOptionsPanel() {
        switch (currentState) {
        case .expanded:
            toggleOptionsPanel()
        default:
            break
        }
    }
    
    func addOptionsViewController() {
        if (optionsViewController == nil) {
            optionsViewController = UIStoryboard.optionsViewController()
            addChildPanelController(optionsViewController!)
        }
    }
    
    func addChildPanelController(optionsViewController: optionsTableViewController) {
        optionsViewController.delegate = centerViewController
        view.insertSubview(optionsViewController.view, atIndex: 0)
        
        addChildViewController(optionsViewController)
        optionsViewController.didMoveToParentViewController(self)
    }
    
    func animateOptionsPanel(shouldExpand shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .expanded
            isExpanded = true
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame) - CGFloat((Float(self.view.bounds.width)/Float(expandedScreenRatio))))
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .collapsed
                isExpanded = false
                self.optionsViewController!.view.removeFromSuperview()
                self.optionsViewController = nil;
                self.centerViewController.changeSlideTutorial()
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
}

extension ContainerViewController: UIGestureRecognizerDelegate {
    // MARK: Gesture recognizer
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
        
        switch(recognizer.state) {
        case .Began:
            if (currentState == .collapsed) {
                if (gestureIsDraggingFromLeftToRight) {
                    addOptionsViewController()
                }
                showShadowForCenterViewController(true)
            }
        case .Changed:
            if (canPanMenu && (gestureIsDraggingFromLeftToRight || currentState == .expanded)){
                recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
                recognizer.setTranslation(CGPointZero, inView: view)
                //println(recognizer.view!.center.x)
            }
        case .Ended:
            if (optionsViewController != nil) {
                // animate the side panel open or closed based on whether the view has moved more or less than halfway
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
                animateOptionsPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
        default:
            break
        }
    }
    
}

private extension UIStoryboard {
  class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
  
  class func optionsViewController() -> optionsTableViewController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("optionsTableViewController") as? optionsTableViewController
  }
  
  class func centerViewController() -> menuViewController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("menuViewController") as? menuViewController
  }
  
}