//
//  VideoTableViewCell.swift
//  YouTube
//
//  Created by Arturs Derkintis on 12/31/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class VideoCell: UICollectionViewCell {
    
    var imageContainer : ParallaxView!
    var thumbnailImageView : ASImageNode!
    var durationLabel : UILabel!
    var viewsCountLabel : UILabel!
    var channelTitleLabel : UILabel!
    var videoTitleLabel : UILabel!
    var topBanner : UIView!
    var created = false
    
    var channelTitleDelgate : ChannelTitleDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        
        imageContainer = ParallaxView(frame: .zero)
        contentView.addSubview(imageContainer)
        imageContainer.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(10)
            make.centerX.equalTo(self)
            make.height.equalTo(self.snp_height).multipliedBy(0.85)
            make.width.equalTo(self.snp_width)
        }
        
        thumbnailImageView = ASImageNode()
        imageContainer.addSubview(thumbnailImageView.view)
        thumbnailImageView.view.snp_makeConstraints { (make) -> Void in
            make.top.left.equalTo(5)
            make.right.bottom.equalTo(-5)
        }
        
        durationLabel = UILabel(frame: .zero)
        imageContainer.addSubview(durationLabel)
        durationLabel.tag = hidableViewTag
        durationLabel.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(-10).priority(1000)
            make.right.equalTo(-10).priority(1000)
            make.height.equalTo(20).priority(1000)
        }
        
        
        topBanner = UIView(frame: .zero)
        topBanner.tag = hidableViewTag
        imageContainer.addSubview(topBanner)
        topBanner.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.top.equalTo(5)
            make.height.equalTo(20)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: "tappedOnChannelTitle")
        topBanner.addGestureRecognizer(tap)
        
        channelTitleLabel = UILabel(frame: .zero)
        channelTitleLabel.tag = hidableViewTag
        imageContainer.addSubview(channelTitleLabel)
        channelTitleLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(5)
            make.right.equalTo(-25)
            make.top.equalTo(5)
            make.height.equalTo(20)
        }

        
        
        viewsCountLabel = UILabel(frame: .zero)
        viewsCountLabel.tag = hidableViewTag
        imageContainer.addSubview(viewsCountLabel)
        viewsCountLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(5)
            make.right.equalTo(-5)
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        
        videoTitleLabel = UILabel(frame: .zero)
        videoTitleLabel.tag = hidableViewTag
        imageContainer.addSubview(videoTitleLabel)
        videoTitleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(thumbnailImageView.view.snp_bottomMargin).offset(13)
            make.height.equalTo(25)
            make.width.equalTo(self.snp_width).multipliedBy(0.9)
            make.centerX.equalTo(self.snp_centerX)
        }
        design()
    }
    
    func tappedOnChannelTitle(){
        channelTitleDelgate?.openChannelForCell(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        durationLabel.text = ""
        viewsCountLabel.text = ""
        thumbnailImageView.image = nil
        channelTitleLabel.text = ""
    }
    
    func design(){
        
        imageContainer.backgroundColor = UIColor.whiteColor()
        imageContainer.layer.cornerRadius = 3
        imageContainer.layer.shadowOffset = CGSize(width: 1, height: 2)
        imageContainer.layer.shadowColor  = UIColor.blackColor().CGColor
        imageContainer.layer.shadowOpacity = 0.17
        imageContainer.layer.shadowRadius = 2
        imageContainer.layer.rasterizationScale = UIScreen.mainScreen().scale
        imageContainer.layer.shouldRasterize = true
        
        topBanner.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        
        channelTitleLabel.font = UIFont.systemFontOfSize(12, weight: UIFontWeightMedium)
        channelTitleLabel.textColor = .blackColor()
        
        viewsCountLabel.textColor = .blackColor()
        viewsCountLabel.font = UIFont.systemFontOfSize(12, weight: UIFontWeightMedium)
        viewsCountLabel.textAlignment = NSTextAlignment.Center
       
        durationLabel.textColor = .whiteColor()
        durationLabel.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        durationLabel.layer.cornerRadius = 2
        durationLabel.font = UIFont.systemFontOfSize(10, weight: UIFontWeightBold)
        durationLabel.layer.borderWidth = 0.5
        durationLabel.layer.masksToBounds = true
        durationLabel.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.8).CGColor
        
        thumbnailImageView.placeholderColor = UIColor(white: 0.9, alpha: 1.0)
        thumbnailImageView.contentMode = .ScaleAspectFill
        thumbnailImageView.layer.masksToBounds = true
        
        videoTitleLabel.textAlignment = .Center
        videoTitleLabel.font = UIFont.systemFontOfSize(13, weight: UIFontWeightRegular)
        
    }
    
  
    
    func setDurationLabelSize(){
        let contentSize = (durationLabel.text! as NSString).sizeWithAttributes([NSFontAttributeName: durationLabel.font])
        durationLabel.frame.size = CGSize(width: contentSize.width, height: 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
