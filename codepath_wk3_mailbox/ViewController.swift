//
//  ViewController.swift
//  codepath_wk3_mailbox
//
//  Created by Ariel Liu on 2/21/16.
//  Copyright © 2016 Ariel Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var feedView: UIImageView!
    @IBOutlet weak var messageView: UIImageView!
    @IBOutlet weak var messageContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scrollView.contentSize = feedView.image!.size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onMessageSwipe(panGestureRecognizer: UIPanGestureRecognizer) {
        let laterBreakpoint = -60
        let listBreakpoint = -260
        let deleteBreakpoint = 260
        let archiveBreakpoint = 60

        var endGestureX = 320 / 2
        
        // Absolute (x,y) coordinates in parent view
        let point = panGestureRecognizer.locationInView(view)
        
        // Relative change in (x,y) coordinates from where gesture began.
        let translation = panGestureRecognizer.translationInView(view)
        let velocity = panGestureRecognizer.velocityInView(view)
        
        messageView.center.x = 320 / 2 + translation.x
        
        messageContainerView.backgroundColor = UIColor.grayColor()
        
        if translation.x < 0 {
            endGestureX = -320 * 3 / 2
            if translation.x < CGFloat(listBreakpoint) {
                messageContainerView.backgroundColor = UIColor.brownColor()
            } else if translation.x < CGFloat(laterBreakpoint) {
                messageContainerView.backgroundColor = UIColor.yellowColor()
            } else {
                endGestureX = -320 / 2
            }
        } else {
            endGestureX = 320 * 3 / 2
            if (translation.x > CGFloat(deleteBreakpoint)) {
                messageContainerView.backgroundColor = UIColor.redColor()
            } else if (translation.x > CGFloat(archiveBreakpoint)) {
                messageContainerView.backgroundColor = UIColor.greenColor()
            } else {
                endGestureX = 320 / 2
            }
        }
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("Gesture began at: \(point)")
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            print("Gesture changed at: \(point)")
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.3, animations: {
                self.messageView.center.x = CGFloat(endGestureX)
            })
            print("Gesture ended at: \(point)")
        }
    }
    


}

