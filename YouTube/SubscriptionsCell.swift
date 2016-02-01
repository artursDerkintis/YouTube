//
//  SubscriptionsCell.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/26/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class SubscriptionsCell: UICollectionViewCell {

    
    var contentHolder : ParallaxView!
    var channelTitleLabel : UILabel!
    var thumbnailImage : ASImageNode!
    var newItemsWarningView : UIView!
    var newItemsWarningLabel : UILabel!
    var circleView : UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentHolder = ParallaxView(frame: .zero)
        contentView.addSubview(contentHolder)
        contentHolder.snp_makeConstraints { (make) -> Void in
            make.top.bottom.left.right.equalTo(0)
        }
        
        contentHolder.layer.masksToBounds = false
        contentHolder.backgroundColor = UIColor.whiteColor()
        contentHolder.layer.shadowOffset = CGSize(width: 1, height: 2)
        contentHolder.layer.shadowColor  = UIColor.blackColor().CGColor
        contentHolder.layer.shadowOpacity = 0.17
        contentHolder.layer.shadowRadius = 2
        contentHolder.layer.rasterizationScale = UIScreen.mainScreen().scale
        contentHolder.layer.shouldRasterize = true
        
        thumbnailImage = ASImageNode()
        contentHolder.addSubview(thumbnailImage.view)
        thumbnailImage.view.snp_makeConstraints { (make) -> Void in
            make.height.width.equalTo(self.contentHolder.snp_width).multipliedBy(0.9)
            make.center.equalTo(self.contentHolder.center)
        }
        thumbnailImage.contentMode = .ScaleAspectFill
        thumbnailImage.view.layer.masksToBounds = true
        circleView = UIView(frame: .zero)
        thumbnailImage.view.addSubview(circleView)
        circleView.snp_makeConstraints { (make) -> Void in
            make.height.width.equalTo(35)
            make.right.equalTo(13)
            make.top.equalTo(-13)
        }
        circleView.layer.cornerRadius = 35 * 0.5
        circleView.backgroundColor = .whiteColor()
    
        channelTitleLabel = UILabel(frame: .zero)
        contentHolder.addSubview(channelTitleLabel)
        channelTitleLabel.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(0)
            make.height.equalTo(20)
            make.top.equalTo(self.thumbnailImage.view.snp_bottomMargin).offset(17)
        }
        channelTitleLabel.font = UIFont.systemFontOfSize(12, weight: UIFontWeightMedium)
        channelTitleLabel.textColor = .blackColor()
        channelTitleLabel.textAlignment = .Center
        
        newItemsWarningView = UIView(frame: .zero)
        contentHolder.addSubview(newItemsWarningView)
        newItemsWarningView.snp_makeConstraints { (make) -> Void in
            make.height.width.equalTo(30)
            make.right.equalTo(6)
            make.top.equalTo(-6)
        }
        newItemsWarningView.layer.cornerRadius = 15
        newItemsWarningView.layer.masksToBounds = true
        newItemsWarningView.backgroundColor = UIColor(red: 0, green: 150/255, blue: 1, alpha: 1.0)
        
        newItemsWarningLabel = UILabel(frame: .zero)
        newItemsWarningView.addSubview(newItemsWarningLabel)
        newItemsWarningLabel.snp_makeConstraints { (make) -> Void in
            make.top.right.left.bottom.equalTo(0)
        }
        newItemsWarningLabel.font = UIFont.systemFontOfSize(10, weight: UIFontWeightBold)
        newItemsWarningLabel.textColor = .whiteColor()
        newItemsWarningLabel.textAlignment = .Center
        contentHolder.layer.cornerRadius = 2.5
        thumbnailImage.view.layer.cornerRadius = 1.5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
