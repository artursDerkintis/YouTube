//
//  VideoView.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/6/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit

class VideoView: UIView {
    var fullscreen = false
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        let extenedRect = CGRect(x: -320, y: 0, width: frame.width + 320, height: frame.height)
        if fullscreen && CGRectContainsPoint(extenedRect, point){
            print(self.frame)
            print(point)
            return true
        }else if !fullscreen && CGRectContainsPoint(bounds, point){
            return true
        }
        return false
    }
}
