//
//  BottomProgress.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/9/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit

class BottomProgress: UIControl {
    var maxValue : Double = 0.0
    
    var value : Double = 0.01{
        didSet{
            let pr = CGFloat(value / maxValue)
            if !value.isNaN && !maxValue.isNaN && !pr.isNaN{
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.progressView.frame = CGRect(x: 0, y: self.frame.height * 0.5 - 2, width: self.frame.width * pr, height: 4)
                })
                
            }
        }
    }

    var progressView : UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        progressView = UIView(frame: .zero)
        progressView.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        addSubview(progressView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}