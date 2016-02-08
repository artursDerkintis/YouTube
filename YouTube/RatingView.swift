//
//  RatingView.swift
//  YouTube
//
//  Created by Arturs Derkintis on 2/6/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit

class RatingView: UIView {
    
    var likeButton : UIButton!
    var dislikeButton : UIButton!
    var videoId : String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        likeButton = UIButton(type: .Custom)
        likeButton.setImage(UIImage(named: "like"), forState: .Normal)
        likeButton.setImage(UIImage(named: "like")?.imageWithColor(UIColor.redColor()), forState: .Selected)
        
        likeButton.titleLabel?.font = UIFont.systemFontOfSize(12, weight: UIFontWeightMedium)
        likeButton.setTitleColor(.blackColor(), forState: .Normal)
        
        addSubview(likeButton)
        likeButton.snp_makeConstraints { (make) -> Void in
            make.top.left.bottom.equalTo(0)
            make.width.equalTo(self.snp_width).multipliedBy(0.5)
        }
        likeButton.imageView?.snp_makeConstraints(closure: { (make) -> Void in
            make.width.height.equalTo(25).priorityRequired()
            make.left.equalTo(0)
            make.centerY.equalTo(self.likeButton.snp_centerY)
        })
        likeButton.titleLabel?.snp_removeConstraints()
        likeButton.titleLabel?.snp_makeConstraints(closure: { (make) -> Void in
            make.left.equalTo(self.likeButton.imageView!.snp_right)
            make.centerY.equalTo(self.likeButton.snp_centerY)
            
        })
        
        likeButton.addTarget(self, action: "like:", forControlEvents: .TouchDown)
        
        dislikeButton = UIButton(type: .Custom)
        dislikeButton.setImage(UIImage(named: "dislike"), forState: .Normal)
        dislikeButton.setImage(UIImage(named: "dislike")?.imageWithColor(UIColor.redColor()), forState: .Selected)
        
        
        dislikeButton.titleLabel?.snp_removeConstraints()
        dislikeButton.titleLabel?.font = UIFont.systemFontOfSize(12, weight: UIFontWeightMedium)
        dislikeButton.setTitleColor(.blackColor(), forState: .Normal)
        dislikeButton.addTarget(self, action: "dislike:", forControlEvents: .TouchDown)
        
        addSubview(dislikeButton)
        dislikeButton.imageView?.snp_makeConstraints(closure: { (make) -> Void in
            make.width.height.equalTo(25).priorityRequired()
            make.left.equalTo(0)
            make.centerY.equalTo(self.dislikeButton.snp_centerY)
        })
        dislikeButton.titleLabel?.snp_makeConstraints(closure: { (make) -> Void in
            make.left.equalTo(self.dislikeButton.imageView!.snp_right)
            make.centerY.equalTo(self.dislikeButton.snp_centerY)
        })
        dislikeButton.snp_makeConstraints { (make) -> Void in
            make.top.right.bottom.equalTo(0)
            make.width.equalTo(self.snp_width).multipliedBy(0.5)
        }
        
        
    }
    
    func like(sender: UIButton){
        if let videoId = videoId{
            if let currentUser = UserHandler.sharedInstance.user{
                if !sender.selected{
                    RatingProvider.sharedInstance.rateVideo(videoId, rating: Rating.Like, accessToken: currentUser.token) { (done) -> Void in
                        onMainThread({ () -> () in
                            if var count = Int(sender.titleLabel!.text!){
                                count += 1
                                sender.setTitle(String(count), forState: .Normal)
                            }
                            sender.selected = true
                            self.dislikeButton.selected = false
                        })
                    }
                }else{
                    RatingProvider.sharedInstance.rateVideo(videoId, rating: Rating.None, accessToken: currentUser.token) { (done) -> Void in
                        onMainThread({ () -> () in
                            if var count = Int(sender.titleLabel!.text!){
                                count -= 1
                                sender.setTitle(String(count), forState: .Normal)
                            }
                            sender.selected = false
                            self.dislikeButton.selected = false
                            
                        })
                    }
                }
            }}
        
    }
    
    func dislike(sender : UIButton){
        if let videoId = videoId{
            if let currentUser = UserHandler.sharedInstance.user{
                if !sender.selected{
                    RatingProvider.sharedInstance.rateVideo(videoId, rating: Rating.Dislike, accessToken: currentUser.token) { (done) -> Void in
                        onMainThread({ () -> () in
                            if var count = Int(sender.titleLabel!.text!){
                                count += 1
                                sender.setTitle(String(count), forState: .Normal)
                                
                            }
                            sender.selected = true
                            self.likeButton.selected = false
                        })
                    }
                }else{
                    RatingProvider.sharedInstance.rateVideo(videoId, rating: Rating.None, accessToken: currentUser.token) { (done) -> Void in
                        onMainThread({ () -> () in
                            if var count = Int(sender.titleLabel!.text!){
                                count -= 1
                                sender.setTitle(String(count), forState: .Normal)
                                
                            }
                            sender.selected = false
                            self.likeButton.selected = false
                        })
                        
                    }
                }
            }
        }
    }
    
    func updateButtons(){
        if let videoId = videoId, currentUser = UserHandler.sharedInstance.user{
            RatingProvider.sharedInstance.getCurrentRating(videoId, accessToken: currentUser.token, completion: { (rating: Rating) -> Void in
                onMainThread({ () -> () in
                    switch rating{
                    case .Like:
                        self.likeButton.selected = true
                        self.dislikeButton.selected = false
                        break
                    case .Dislike:
                        self.likeButton.selected = false
                        self.dislikeButton.selected = true
                        break
                    case .None, .Unspecified:
                        self.dislikeButton.selected = false
                        self.likeButton.selected = false
                        break
                        
                    }
                })
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIImage{
    
    func imageWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext() as CGContextRef!
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        color.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}

func onMainThread(closure:() -> ()){
    dispatch_async(dispatch_get_main_queue(), closure)
}