//
//  ChannelTableViewCell.swift
//  YouTube
//
//  Created by Arturs Derkintis on 12/31/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class ChannelCell: UICollectionViewCell{
    
    var imageContainer : ParallaxView!
    var thumbnailImageView : UIImageView!
    var subscriberCountLabel : UILabel!
    var channelTitleLabel : UILabel!
    
    var created = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        
        imageContainer = ParallaxView(frame: .zero)
        contentView.addSubview(imageContainer)
        imageContainer.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(10)
            make.centerX.equalTo(self)
            make.height.equalTo(138)
            make.width.equalTo(250)
        }
        
        thumbnailImageView = UIImageView(frame: .zero)
        thumbnailImageView.contentMode = .ScaleAspectFill
        imageContainer.addSubview(thumbnailImageView)
        thumbnailImageView.snp_makeConstraints { (make) -> Void in
            make.top.left.equalTo(5)
            make.bottom.equalTo(-5)
            make.width.equalTo(self.snp_width).multipliedBy(0.4)
        }
        
        channelTitleLabel = UILabel(frame: .zero)
        channelTitleLabel.tag = hidableViewTag
        imageContainer.addSubview(channelTitleLabel)
        channelTitleLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(thumbnailImageView.snp_rightMargin).offset(15)
            make.right.equalTo(-10)
            make.top.equalTo(45)
            make.height.equalTo(25)
        }
        
        subscriberCountLabel = UILabel(frame: .zero)
        imageContainer.addSubview(subscriberCountLabel)
        subscriberCountLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(thumbnailImageView.snp_rightMargin).offset(15)
            make.top.equalTo(channelTitleLabel.snp_bottomMargin).offset(5)
            make.height.equalTo(25)
            make.right.equalTo(-10)
        }
        
        
        design()
    }
    
    func design(){
        imageContainer.backgroundColor = UIColor.whiteColor()
        imageContainer.layer.cornerRadius = 3
        imageContainer.layer.shadowOffset = CGSize(width: 1, height: 2)
        imageContainer.layer.shadowColor  = UIColor.blackColor().CGColor
        imageContainer.layer.shadowOpacity = 0.17
        imageContainer.layer.shadowRadius = 2
        
        channelTitleLabel.font = UIFont.systemFontOfSize(13, weight: UIFontWeightMedium)
        channelTitleLabel.textAlignment = .Center
        subscriberCountLabel.font = UIFont.systemFontOfSize(12, weight: UIFontWeightRegular)
        subscriberCountLabel.textColor = UIColor.lightGrayColor()
        subscriberCountLabel.textAlignment = .Center
        thumbnailImageView.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
