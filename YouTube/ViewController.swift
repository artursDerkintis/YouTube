//
//  ViewController.swift
//  YouTube
//
//  Created by Arturs Derkintis on 12/29/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import SnapKit



class ViewController: UIViewController {
    var videoController : VideoViewController!
    var browseVC : BrowseViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // Do any additional setup after loading the view, typically from a nib.

        let background = UIImageView(frame: .zero)
        view.addSubview(background)
        background.image = UIImage(named: "background2")
        background.snp_makeConstraints { (make) -> Void in
            make.top.left.equalTo(0)
            make.bottom.right.equalTo(0)
        }
        let blur = UIVisualEffectView(frame: CGRect.zero)
        
        blur.layer.masksToBounds = true
        blur.effect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        
        view.addSubview(blur)
        blur.snp_makeConstraints { (make) -> Void in
            make.right.left.top.bottom.equalTo(0)
        }

        let search = FinderController()
        addChildViewController(search)
            view.addSubview(search.view)
            search.view.snp_makeConstraints { (make) -> Void in
                make.top.left.equalTo(0)
                make.bottom.equalTo(0)
                make.width.equalTo(320)
            }
        
        browseVC = BrowseViewController()
        addChildViewController(browseVC)
        self.view.addSubview(browseVC.view)
        browseVC.view.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(320)
            make.right.equalTo(-20)
            make.top.bottom.equalTo(0)
        }
        
        videoController = VideoViewController()
        view.addSubview(videoController.view)
        videoController.view.snp_makeConstraints { (make) -> Void in
            make.top.bottom.equalTo(0)
            make.left.equalTo(self.view.snp_right).offset(-20)
            make.width.equalTo(700)
        }
        
        
        
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    override func shouldAutorotate() -> Bool {
        return false
    }
    
       
     override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

