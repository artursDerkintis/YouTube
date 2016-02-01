//
//  Slider.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/6/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit

class Slider: UIControl {
    var canMove = false
    var backgroundLayer : UIView!
    var progressLayer : UIView!
    var circleHandle : UIView!
    var decProgress : Double = 0.0
    var maxValue : Double = 0.0
    
    var value : Double = 0.01{
        didSet{
            let pr = CGFloat(value / maxValue)
            if !value.isNaN && !maxValue.isNaN && !pr.isNaN{
                if !canMove{
                    progressLayer.frame = CGRect(x: 0, y: frame.height * 0.5 - 2, width: frame.width * pr, height: 4)
                    circleHandle.center = CGPoint(x: frame.width * pr, y: frame.height * 0.5)
                }
        }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundLayer = UIView(frame: .zero)
        backgroundLayer.backgroundColor = UIColor(white: 0.75, alpha: 1.0)
        backgroundLayer.layer.shadowColor = UIColor(red: 1, green: 70/255, blue: 144/255, alpha: 1.0).CGColor
        backgroundLayer.layer.shadowOffset = .zero
        backgroundLayer.layer.shadowOpacity = 1.0
        backgroundLayer.layer.shadowRadius = 5
        backgroundLayer.layer.cornerRadius = 2
        addSubview(backgroundLayer)
        backgroundLayer.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(0)
            make.height.equalTo(4)
            make.centerY.equalTo(self.snp_centerY)
        }
        progressLayer = UIView(frame: .zero)
        progressLayer.backgroundColor = UIColor(red: 1, green: 67/255, blue: 54/255, alpha: 1.0)
        progressLayer.layer.cornerRadius = 2
        addSubview(progressLayer)
        circleHandle = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        addSubview(circleHandle)
        
        let handleImageView = UIImageView(image: UIImage(named: "handle"))
        circleHandle.addSubview(handleImageView)
        handleImageView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.circleHandle.snp_center)
            make.height.width.equalTo(20)
        }
        
        let pan = UIPanGestureRecognizer(target: self, action: "pan:")
        addGestureRecognizer(pan)
        
    }
    
    func pan(sender : UIPanGestureRecognizer){
        let location = sender.locationInView(self)
        
        if sender.state == .Began{
            if CGRectContainsPoint(circleHandle.frame, location){
                if location.x >= 0 && location.x <= self.frame.width{
                    circleHandle.center = CGPoint(x: location.x, y: circleHandle.center.y)
                    canMove = true
                }
            }
        }else if sender.state == .Changed{
            if location.x >= 0 && location.x <= self.frame.width{
                let n1 = Double(location.x / self.frame.width)
                decProgress = n1 * maxValue
                progressLayer.frame = CGRect(x: 0, y: frame.height * 0.5 - 2, width: frame.width * CGFloat(n1), height: 4)
                circleHandle.center = CGPoint(x: location.x, y: circleHandle.center.y)
                sendActionsForControlEvents(.ValueChanged)
            }
        }else if sender.state == .Ended{
            canMove = false
        }
    }
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if CGRectContainsPoint(CGRect(x: -25, y: 0, width: frame.width + 25, height: frame.height), point){
            return true
        }
        return false
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundLayer.frame = CGRect(x: 0, y: self.frame.height * 0.5 - 2, width: self.frame.width, height: 4)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
