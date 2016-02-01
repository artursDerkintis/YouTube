//
//  ProgressBar.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/6/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit

class ProgressBar: UIControl {
    
    var slider : Slider!
    
    var duration : UILabel!
    var curentTime : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        slider = Slider(frame: .zero)
        addSubview(slider)
        slider.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(70)
            make.right.equalTo(-70)
            make.top.bottom.equalTo(0)
        }
        duration = UILabel(frame: .zero)
        addSubview(duration)
        duration.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(slider.snp_rightMargin)
            make.right.bottom.top.equalTo(0)
        }
        
        curentTime = UILabel(frame: .zero)
        addSubview(curentTime)
        curentTime.snp_makeConstraints { (make) -> Void in
            make.left.bottom.top.equalTo(0)
            make.right.equalTo(slider.snp_leftMargin)
        }
        
        curentTime.text = "--:--"
        duration.text = "--:--"
        
        curentTime.font = UIFont.systemFontOfSize(12, weight: UIFontWeightMedium)
        curentTime.textColor = UIColor.whiteColor()
        curentTime.textAlignment = .Center
        curentTime.layer.shadowColor = UIColor.blackColor().CGColor
        curentTime.layer.shadowOffset = CGSize(width: 0.0, height: 1)
        curentTime.layer.shadowRadius = 0
        curentTime.layer.shouldRasterize = true
        curentTime.layer.rasterizationScale = UIScreen.mainScreen().scale
        duration.font = UIFont.systemFontOfSize(12, weight: UIFontWeightMedium)
        duration.textColor = UIColor.whiteColor()
        duration.textAlignment = .Center
        duration.layer.shadowColor = UIColor.blackColor().CGColor
        duration.layer.shadowOffset = CGSize(width: 0.0, height: 1)
        duration.layer.shadowRadius = 0
        duration.layer.shouldRasterize = true
        duration.layer.rasterizationScale = UIScreen.mainScreen().scale
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

public func secondsToHoursMinutesSeconds (seconds : Float64) -> String {
    
    let hr = Int(floor(seconds / 3600))
    let min = Int(floor(seconds % 3600 / 60))
    let sec = Int(floor(seconds % 3600 % 60))
    
    let strSeconds = sec > 9 ? String(sec) : "0" + String(sec)
    if hr > 0{
        let strMinutes = min > 9 ? String(min) : "0" + String(min)
        return "\(hr):\(strMinutes):\(strSeconds)"
    }else{
        return "\(min):\(strSeconds)"
    }
}
