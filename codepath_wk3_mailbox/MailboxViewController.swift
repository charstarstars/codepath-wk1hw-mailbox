//
//  MailboxViewController.swift
//  codepath_wk3_mailbox
//
//  Created by Ariel Liu on 2/21/16.
//  Copyright © 2016 Ariel Liu. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var feedView: UIImageView!
    @IBOutlet weak var messageView: UIImageView!
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var archiveIconView: UIImageView!
    @IBOutlet weak var deleteIconView: UIImageView!
    @IBOutlet weak var laterIconView: UIImageView!
    @IBOutlet weak var listIconView: UIImageView!
    @IBOutlet weak var laterSplashView: UIImageView!
    @IBOutlet weak var listSplashView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scrollView.contentSize = feedView.image!.size
        
        archiveIconView.alpha = 0
        deleteIconView.alpha = 0
        laterIconView.alpha = 0
        listIconView.alpha = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideMessage() {
        UIView.animateWithDuration(0.2, animations: {
            self.feedView.frame.origin.y = -self.messageView.frame.height
            self.messageContainerView.frame.origin.y = -self.messageView.frame.height
            },completion: {
                (Bool) in
                
                self.messageView.frame.origin.x = 0
                
                UIView.animateWithDuration(0.2, animations: {
                    self.feedView.frame.origin.y = 0
                    self.messageContainerView.frame.origin.y = 0
                })
                
        })
    }
    
    @IBAction func onSplashTap(sender: UITapGestureRecognizer) {
        sender.view!.alpha = 0
        hideMessage()
    }
    
    @IBAction func onMessageSwipe(panGestureRecognizer: UIPanGestureRecognizer) {
        let laterBreakpoint = -60
        let listBreakpoint = -260
        let deleteBreakpoint = 260
        let archiveBreakpoint = 60
        
        var endGestureX:CGFloat!
        var iconToShow:UIImageView!
        var breakpoint:Int!
        
        // Absolute (x,y) coordinates in parent view
        let point = panGestureRecognizer.locationInView(view)
        
        // Relative change in (x,y) coordinates from where gesture began.
        let translation = panGestureRecognizer.translationInView(view)
        let velocity = panGestureRecognizer.velocityInView(view)
        
        messageView.center.x = 320 / 2 + translation.x
        
        messageContainerView.backgroundColor = UIColor.grayColor()
        
        listIconView.alpha = 0
        deleteIconView.alpha = 0
        archiveIconView.alpha = 0
        laterIconView.alpha = 0
        if translation.x < 0 {
            endGestureX = -view.frame.width
            breakpoint = laterBreakpoint + 10
            iconToShow = laterIconView
            if translation.x < CGFloat(listBreakpoint) {
                messageContainerView.backgroundColor = UIColor.brownColor()
                iconToShow = listIconView
            } else if translation.x < CGFloat(laterBreakpoint) {
                messageContainerView.backgroundColor = UIColor.orangeColor()
            } else {
                
                endGestureX = 0
            }

        } else {
            endGestureX = view.frame.width
            breakpoint = archiveBreakpoint - 10
            iconToShow = archiveIconView
            if (translation.x > CGFloat(deleteBreakpoint)) {
                messageContainerView.backgroundColor = UIColor.redColor()
                iconToShow = deleteIconView
            } else if (translation.x > CGFloat(archiveBreakpoint)) {
                messageContainerView.backgroundColor = UIColor.greenColor()
            } else {
                endGestureX = 0
            }
        }
        
        iconToShow.alpha = translation.x / CGFloat(breakpoint)
        if abs(translation.x) > abs(CGFloat(breakpoint)) {
            iconToShow.transform = CGAffineTransformMakeTranslation(translation.x - CGFloat(breakpoint), 0)
        }
        
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("Gesture began at: \(point)")
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            print("Gesture changed at: \(point)")
            
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.3, animations: {
                self.messageView.frame.origin.x = endGestureX
                iconToShow.transform = CGAffineTransformMakeTranslation(endGestureX - CGFloat(breakpoint - 10), 0)
                }, completion: {
                    (value: Bool) in
                    if iconToShow == self.laterIconView {
                        self.laterSplashView.alpha = 1
                    } else if iconToShow == self.listIconView {
                        self.listSplashView.alpha = 1
                    } else if iconToShow != nil {
                        self.hideMessage()
                    }
            })
            print("Gesture ended at: \(point)")
        }
    }
}
