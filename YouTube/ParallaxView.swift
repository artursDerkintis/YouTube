//
//  ParallaxView.swift
//  YouTube
//
//  Created by Arturs Derkintis on 12/31/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
let hidableViewTag = 7175
class ParallaxView: UIView, UIGestureRecognizerDelegate {
    
    var timer : NSTimer?
    dynamic var parallax = false
    var longRec : UILongPressGestureRecognizer!
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        longRec = UILongPressGestureRecognizer(target: self, action: "long:")
        longRec.minimumPressDuration = 0.3
       
        addGestureRecognizer(longRec)
    }
    
    
    func long(sender : UILongPressGestureRecognizer){
        if sender.state == .Began{
            allowParallax()
        }else if sender.state == .Changed{
            if parallax{
                let point = sender.locationInView(self)
                if CGRectContainsPoint(self.superview!.frame, point){
                    let newX = point.x - (bounds.width / 2)
                    let newY = abs(point.y - (bounds.height / 2))
                    
                    layer.zPosition = 100
                    var rotationAndPerspectiveTransform = CATransform3DIdentity;
                    rotationAndPerspectiveTransform.m34 = 1.0 / -500;
                    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,
                        (-newX / 7) * CGFloat(M_PI) / 180.0,
                        -newY / 7,
                        10.0,
                        0.0)
                    UIView.animateWithDuration(0.3) { () -> Void in
                        self.layer.transform = rotationAndPerspectiveTransform
                    }
                }else{
                    endParallax()
                }
            }

        }else if sender.state == .Ended{
            endParallax()
        }
    }
  
    func pan(panGesture : UIPanGestureRecognizer){
        switch panGesture.state{
        case .Began:
            longRec.enabled = false
            break
        case .Changed:
            if parallax{
                
                let point = panGesture.locationInView(self)
                if CGRectContainsPoint(self.superview!.frame, point){
                    let newX = point.x - bounds.width / 2
                    var newY = point.y - bounds.height / 2
                    if newY < 0{
                        newY = newY * -1
                    }
                    layer.zPosition = 100
                    var rotationAndPerspectiveTransform = CATransform3DIdentity;
                    rotationAndPerspectiveTransform.m34 = 1.0 / -500;
                    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,
                        (-newX / 5) * CGFloat(M_PI) / 180.0,
                        -newY / 5,
                        4.0,
                        0.0)
                    UIView.animateWithDuration(0.3) { () -> Void in
                        self.layer.transform = rotationAndPerspectiveTransform
                    }
                }else{
                    endParallax()
                }
            }
            break
        case .Ended, .Failed, .Cancelled:
            endParallax()
            break
        default:
            break
        }
    }
    func allowParallax(){
        parallax = true
        UIView.animateWithDuration(0.3) { () -> Void in
            self.setAlphaForViews(0.0)
        }
    }
    deinit{
        
    }
    /*override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("Start")
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "allowParallax", userInfo: nil, repeats: false)
        
    }
    
   
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("It recognizes touch")
        
        if parallax{
            if let touch = touches.first {
                let point = touch.locationInView(self)
                if CGRectContainsPoint(self.frame, point){
                    let newX = point.x - bounds.width / 2
                    var newY = point.y - bounds.height / 2
                    if newY < 0{
                        newY = newY * -1
                    }
                    layer.zPosition = 100
                    var rotationAndPerspectiveTransform = CATransform3DIdentity;
                    rotationAndPerspectiveTransform.m34 = 1.0 / -500;
                    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,
                        (-newX / 5) * CGFloat(M_PI) / 180.0,
                        -newY / 5,
                        4.0,
                        0.0)
                    UIView.animateWithDuration(0.3) { () -> Void in
                        self.layer.transform = rotationAndPerspectiveTransform
                    }
                }else{
                    endParallax()
                }
            }
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        endParallax()
    }*/
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func endParallax(){
        timer?.invalidate()
        UIView.animateWithDuration(0.3) { () -> Void in
            self.setAlphaForViews(1.0)
            self.layer.transform = CATransform3DIdentity
        }
        parallax = false
        longRec.enabled = true
    }
    
    func setAlphaForViews(alpha : CGFloat){
        for subview in subviews{
            if subview.tag == hidableViewTag{
                subview.alpha = alpha
            }
        }
    }
    
}
