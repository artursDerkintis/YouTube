//
//  VideoViewController.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/9/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit

protocol VideoDelegate{
    func hide()
    func removeDescription()
    
    func show()
}


class VideoViewController: UIViewController, VideoDelegate {
    var playerController : VideoController!
    var descriptionController : DescriptionController!
    var suggestions : SuggestedVideosController!
    var slidderView : UIView!
    var hidden = true{
        didSet{
            if hidden && playerController.player.rate > 0.0 && !playerController.pictureInPictureController.pictureInPictureActive {
                playerController.pip()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blur = UIVisualEffectView(frame: CGRect.zero)
        
        blur.layer.masksToBounds = true
        blur.effect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        
        view.addSubview(blur)
        blur.snp_makeConstraints { (make) -> Void in
            make.right.left.top.bottom.equalTo(0)
        }
        
        let leftLine = CALayer()
        leftLine.frame = CGRect(x: 0, y: 0, width: 1, height: 1024)
        leftLine.backgroundColor = UIColor(white: 0.8, alpha: 1.0).CGColor
        view.layer.addSublayer(leftLine)
        
        playerController = VideoController()
        playerController.delegate = self
        
        addChildViewController(playerController)
        view.addSubview(playerController.view)
        playerController.view.snp_makeConstraints { (make) -> Void in
            make.top.right.equalTo(0)
            make.height.equalTo(self.view.snp_height).multipliedBy(0.55)
            make.left.equalTo(0)
        }
        
        descriptionController = DescriptionController()
        addChildViewController(descriptionController)
        view.addSubview(descriptionController.view)
        descriptionController.view.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(playerController.view.snp_bottom)
            make.bottom.equalTo(-170)
            make.right.left.equalTo(0)
        }
        suggestions = SuggestedVideosController()
        addChildViewController(suggestions)
        view.addSubview(suggestions.view)
        
        suggestions.view.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(0)
            make.height.equalTo(220)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
        
        slidderView = UIView(frame: .zero)
        slidderView.tag = 90
        view.addSubview(slidderView)
        slidderView.snp_makeConstraints { (make) -> Void in
            make.top.left.bottom.equalTo(0)
            make.width.equalTo(30)
        }
        let image = UIImageView(image: UIImage(named: "tile"))
        slidderView.addSubview(image)
        image.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(5)
            make.right.equalTo(-21)
            make.height.equalTo(30)
            make.centerY.equalTo(slidderView.snp_centerY)
        }
        let tap = UITapGestureRecognizer(target: self, action: "toogle")
        slidderView.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: "pan:")
        self.view.addGestureRecognizer(pan)
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationWillResignActiveNotification, object: nil, queue: nil) { (ni) -> Void in
            if self.playerController.player.rate > 0.0 && !self.playerController.pictureInPictureController.pictureInPictureActive {
                self.playerController.pip()
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playVideo:", name: videoNotification, object: nil)
        
    }
    func playVideo(notification : NSNotification) {
        if let video = notification.object as? Video{
            playerController.playVideo(video.videoDetails!)
            suggestions.getSuggestions(video.videoDetails!.id!)
            descriptionController.loadVideoDetails(video)
        }else if let fav = notification.object as? Favorites{
            let video = Video()
            video.getVideoDetails(fav.id!, completion: { (videoDetails) -> Void in
                video.videoDetails = videoDetails
                self.playerController.playVideo(video.videoDetails!)
                self.suggestions.getSuggestions(video.videoDetails!.id!)
            })
            video.getChannelDetails(fav.channelID!, completion: { (channelDetails) -> Void in
                video.channel = channelDetails
                self.descriptionController.loadVideoDetails(video)
            })
        }
    }

    func toogle(){
        hidden ? show() : hide()
    }
    
    func show(){
        self.view.userInteractionEnabled = true
        self.view.snp_updateConstraints { (make) -> Void in
            if let superView = self.view.superview{
                make.left.equalTo(superView.snp_right).offset(-700)
            }
        }
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [UIViewAnimationOptions.CurveEaseInOut], animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { (finc) -> Void in
                
        }
        hidden = false
    }
    func hide(){
        self.view.snp_updateConstraints { (make) -> Void in
            if let superView = self.view.superview{
                make.left.equalTo(superView.snp_right).offset(-20)
            }
        }
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [UIViewAnimationOptions.CurveEaseInOut], animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { (finc) -> Void in
                
        }
        hidden = true
    }
    
    
    var panCoord = CGPointZero
    var velocityX = CGFloat(0)
    func pan(sender : UIPanGestureRecognizer){
        
        switch sender.state{
        case .Began:
            self.panCoord = sender.locationInView(sender.view)
            break
        case .Changed:
            let newCoord = sender.locationInView(sender.view)
            let velocity = sender.velocityInView(sender.view)
            print(velocity.x)
            velocityX = velocity.x
            let x = newCoord.x - panCoord.x
             if let superView = self.view.superview{
                if self.view.frame.origin.x >= superView.frame.width - self.view.frame.width{
                    self.view.frame = CGRect(x: self.view.frame.origin.x + x, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                }
            }
            
            break
        case .Ended, .Cancelled, .Failed:
            if let superView = self.view.superview{
                if velocityX > 1000{
                    self.view.snp_updateConstraints { (make) -> Void in
                        if let superView = self.view.superview{
                            make.left.equalTo(superView.snp_right).offset(-700)
                        }
                    }
                    hide()
                }else if velocityX < -1000{
                    self.view.snp_updateConstraints { (make) -> Void in
                        if let superView = self.view.superview{
                            make.left.equalTo(superView.snp_right).offset(-20)
                        }
                    }
                    show()
                }else if self.view.frame.origin.x > superView.frame.width - (self.view.frame.width * 0.5){
                    self.view.snp_updateConstraints { (make) -> Void in
                        if let superView = self.view.superview{
                            make.left.equalTo(superView.snp_right).offset(-700)
                        }
                    }
                    hide()
                }else{
                    self.view.snp_updateConstraints { (make) -> Void in
                        if let superView = self.view.superview{
                            make.left.equalTo(superView.snp_right).offset(-20)
                        }
                    }
                    show()
                }
            }
            break
        default:break
        }
    }
    
    func removeDescription() {
        self.view.userInteractionEnabled = false
        descriptionController.clearAll()
        suggestions.videos = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
