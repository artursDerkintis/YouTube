//
//  BrowseTopView.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/27/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit

class BrowseTopView: UIView {
    
    var contentView : UIView!
    var backButton : UIButton!
    var imageView : UIImageView!
    var titleLabel : UILabel!
    var detailsLabel : UILabel!
    
    var subscribe : UIButton!
    
    var currentChannelId : String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = UIView(frame: .zero)
        
        contentView.layer.cornerRadius = 2.5
        contentView.backgroundColor = .whiteColor()
        
        addSubview(contentView)
        contentView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(15)
            make.right.equalTo(-15)
            make.left.equalTo(15)
            make.height.equalTo(38)
        }
        
        
        
        backButton = UIButton(type: .Custom)
        
        backButton.setImage(UIImage(named: "back"), forState: .Normal)
        backButton.contentMode = .ScaleAspectFill
        backButton.imageView?.snp_makeConstraints(closure: { (make) -> Void in
            make.width.equalTo(10)
            make.height.equalTo(15)
            make.center.equalTo(self.backButton.center)
        })
        
        let v = UIView(frame: .zero)
        
        imageView = UIImageView(frame: .zero)
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        v.addSubview(imageView)
        titleLabel = UILabel(frame: .zero)
        
        titleLabel.font = UIFont.systemFontOfSize(15, weight: UIFontWeightMedium)
        titleLabel.textColor = .blackColor()
        
        detailsLabel = UILabel(frame: .zero)
        
        detailsLabel.font = UIFont.systemFontOfSize(13, weight: UIFontWeightMedium)
        detailsLabel.textColor = UIColor.grayColor()
        detailsLabel.textAlignment = .Right
        
        let vv = UIView(frame: .zero)
        subscribe = UIButton(type: .Custom)
        vv.addSubview(subscribe)
        
        subscribe.titleLabel?.font = UIFont.systemFontOfSize(12, weight: UIFontWeightBold)
        subscribe.layer.cornerRadius = 2.5
        
        let stackView = UIStackView(arrangedSubviews: [backButton, v, titleLabel, detailsLabel, vv])
        
        stackView.distribution = .FillProportionally
        contentView.addSubview(stackView)
        
        stackView.snp_makeConstraints { (make) -> Void in
            make.top.left.right.bottom.equalTo(0)
        }
        
        
        backButton.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(37)
        }
        
        v.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(40)
        }
        imageView.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(30)
            make.center.equalTo(v.center)
        }
        
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.width.greaterThanOrEqualTo(300)
        }
        detailsLabel.snp_makeConstraints { (make) -> Void in
            make.width.greaterThanOrEqualTo(150)
        }
        detailsLabel.textAlignment = .Right
        
        vv.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(120)
        }
        subscribe.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(25)
            make.center.equalTo(vv.center)
        }
        
        subscribe.addTarget(self, action: "subscribeOrUnsubscribe:", forControlEvents: .TouchDown)
        
    }
    
    func subscribeOrUnsubscribe(sender: UIButton){
        if let currentId = currentChannelId{
            SubscribeModel.sharedInstance.subscibeToChannel(currentId, accessToken: currentUser.token, completion: { (success) -> Void in
                sender.setTitle("✓ Subscribed", forState: .Normal)
                sender.backgroundColor = UIColor.clearColor()
                sender.setTitleColor(.grayColor(), forState: .Normal)
                sender.tag = 2
            })
        }
    }
    
    func setDetails(title: String, thumbnail : String, description : String, subscribed : Subscribed){
        titleLabel.text = title
        ImageDownloader.sharedInstance.getImageAtURL(thumbnail) { (image) -> Void in
            self.imageView.image = image
        }
        detailsLabel.text = description
        subscribe.hidden = false
        if subscribed == .NotSubscribed{
            subscribe.setTitle("Subscribe", forState: .Normal)
            subscribe.tag = 1
            subscribe.backgroundColor = UIColor.redColor()
            subscribe.setTitleColor(.whiteColor(), forState: .Normal)
        }else if subscribed == .Subscribed{
            subscribe.setTitle("✓ Subscribed", forState: .Normal)
            subscribe.backgroundColor = UIColor.clearColor()
            subscribe.tag = 2
            subscribe.setTitleColor(.grayColor(), forState: .Normal)
        }else if subscribed == .Unknown{
            subscribe.hidden = true
            subscribe.tag = 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

enum Subscribed{
    case Subscribed
    case NotSubscribed
    case Unknown
}