//
//  TitleView.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/10/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class TitleView: UIView {
    var contentView : UIView!
    var titleLabel : UILabel!
    var viewsCountLabel : UILabel!
    var descrpitionTextView : UITextView!
    var channelTitleLabel : UILabel!
    
    var channelImageView : ASImageNode!
    
    
    var expandButton : UIButton!
    var likeButton : UIButton!
    var dislikeButton : UIButton!
    var commentsButton : UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.75)
        layer.shadowOffset = CGSize(width: 0.5, height: 7)
        layer.shadowOpacity = 0.17
        layer.shadowRadius = 6
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
        
        contentView = UIView(frame: .zero)
        addSubview(contentView)
        contentView.snp_makeConstraints { (make) -> Void in
            make.top.bottom.right.left.equalTo(0)
        }
        
        titleLabel = UILabel(frame: .zero)
        contentView.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(10)
            make.right.equalTo(-45)
            make.left.equalTo(15)
            make.height.equalTo(25)
        }
        titleLabel.font = UIFont.systemFontOfSize(15, weight: UIFontWeightMedium)
        titleLabel.textColor = .blackColor()
        
        viewsCountLabel = UILabel(frame : .zero)
        contentView.addSubview(viewsCountLabel)
        viewsCountLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.titleLabel.snp_bottom)
            make.left.equalTo(15)
            make.height.equalTo(30)
            make.width.equalTo(self.snp_width).multipliedBy(0.5)
        }
        viewsCountLabel.font = UIFont.systemFontOfSize(13, weight: UIFontWeightSemibold)
        viewsCountLabel.textColor = .blackColor()

        channelImageView = ASImageNode()
        contentView.addSubview(channelImageView.view)
        channelImageView.view.snp_makeConstraints { (make) -> Void in
            make.height.width.equalTo(20)
            make.left.equalTo(15)
            make.top.equalTo(self.viewsCountLabel.snp_bottom).offset(5)
        }
        channelImageView.view.layer.cornerRadius = 10
        channelImageView.view.layer.masksToBounds = true
        
        channelTitleLabel = UILabel(frame: .zero)
        contentView.addSubview(channelTitleLabel)
        channelTitleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.viewsCountLabel.snp_bottom)
            make.left.equalTo(self.channelImageView.view.snp_right).offset(5)
            make.height.equalTo(30)
            make.right.equalTo(0)
        }
        channelTitleLabel.font = UIFont.systemFontOfSize(12, weight: UIFontWeightRegular)
        channelTitleLabel.textColor = .blackColor()
        
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
