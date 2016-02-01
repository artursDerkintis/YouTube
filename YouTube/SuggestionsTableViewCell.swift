//
//  SuggestionsTableViewCell.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/3/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit

class SuggestionsTableViewCell: UITableViewCell {
    
    var titleLabelV : UILabel!
    var putTextButton : UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabelV = UILabel(frame: .zero)
        contentView.addSubview(titleLabelV)
        contentView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(1)
            make.right.left.equalTo(0)
            make.bottom.equalTo(-1)
        }
        titleLabelV.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(38)
            make.right.equalTo(-10)
            make.height.equalTo(contentView.snp_height)
        }
        titleLabelV.font = UIFont.systemFontOfSize(13, weight: UIFontWeightRegular)
        titleLabelV.textColor = UIColor(white: 0.15, alpha: 1.0)
        contentView.layer.cornerRadius = 2.5
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor.whiteColor()
        backgroundColor = .clearColor()
        
        putTextButton = UIButton(type: .Custom)
        contentView.addSubview(putTextButton)
        putTextButton.snp_makeConstraints { (make) -> Void in
            make.top.bottom.left.equalTo(0)
            make.width.equalTo(contentView.snp_height)
        }
        putTextButton.setImage(UIImage(named: "arrow"), forState: .Normal)
        putTextButton.imageView?.contentMode = .ScaleAspectFit
        putTextButton.imageView?.snp_makeConstraints(closure: { (make) -> Void in
            make.top.left.equalTo(13)
            make.bottom.right.equalTo(-13)
        })
        
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        backgroundColor = .clearColor()
        // Configure the view for the selected state
    }

}
