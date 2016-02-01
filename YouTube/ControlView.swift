//
//  ControlView.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/6/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit

class ControlView: UIView {
    var playPauseButton : UIButton!
    var fullscreenButton : UIButton!
    var pipButton : UIButton!
    var qualityButton : UIButton!
    var bookmarkButton : UIButton!
    var closeVideoButton : UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        playPauseButton = UIButton(type: .Custom)
        playPauseButton.setImage(UIImage(named: "play"), forState: .Normal)
        playPauseButton.setImage(UIImage(named: "pause"), forState: .Selected)
        addSubview(playPauseButton)
       
        
        
        fullscreenButton = UIButton(type: .Custom)
        fullscreenButton.setImage(UIImage(named: "full"), forState: .Normal)
        fullscreenButton.setImage(UIImage(named: "small"), forState: .Selected)
        addSubview(fullscreenButton)
        
        
        
        
        pipButton = UIButton(type: .Custom)
        pipButton.setImage(UIImage(named: "pip"), forState: .Normal)
        addSubview(pipButton)
        
        
        qualityButton = UIButton(type: .Custom)
        qualityButton.setImage(UIImage(named: "quality"), forState: .Normal)
        qualityButton.setImage(UIImage(named: "qualityhd"), forState: .Selected)
        
        addSubview(qualityButton)
        
        bookmarkButton = UIButton(type: .Custom)
        bookmarkButton.setImage(UIImage(named: "bookmark"), forState: .Normal)
        bookmarkButton.setImage(UIImage(named: "bookmarkfilled"), forState: .Disabled)
        
        addSubview(bookmarkButton)
        
        let stackView = UIStackView(arrangedSubviews: [bookmarkButton, qualityButton, playPauseButton, pipButton, fullscreenButton])
        stackView.distribution = .FillEqually
        stackView.axis = .Horizontal
        stackView.spacing = 30
        addSubview(stackView)
        stackView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(370)
            make.height.equalTo(50)
            make.center.equalTo(self.snp_center)
        }
        
        closeVideoButton = UIButton(type: .Custom)
        closeVideoButton.setImage(UIImage(named: "closevideo"), forState: .Normal)
        addSubview(closeVideoButton)
        
        closeVideoButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(30)
            make.right.equalTo(-30)
            make.width.height.equalTo(50)
        }
        
    }
    
    func setButtonActions(target : AnyObject){
        fullscreenButton.addTarget(target, action: "full:", forControlEvents: .TouchDown)
        pipButton.addTarget(target, action: "pip", forControlEvents: .TouchDown)
        playPauseButton.addTarget(target, action: "play:", forControlEvents: .TouchDown)
        qualityButton.addTarget(target, action: "changeQuality:", forControlEvents: .TouchDown)
        closeVideoButton.addTarget(target, action: "closeVideo", forControlEvents: .TouchUpInside)
        bookmarkButton.addTarget(target, action: "favorite", forControlEvents: .TouchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
