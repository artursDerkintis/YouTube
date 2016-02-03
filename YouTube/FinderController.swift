//
//  FinderController.swift
//  YouTube
//
//  Created by Arturs Derkintis on 2/1/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit

class FinderController: UIViewController {
    
    var navigator : UIView!
    
    var searchButton : UIButton!
    var favButton : UIButton!
    
    var searchViewC : SearchViewController!
    var favViewC : FavoritesController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favViewC = FavoritesController()
        self.view.addSubview(favViewC.view)
        
        favViewC.view.snp_makeConstraints { (make) -> Void in
            make.top.right.left.bottom.equalTo(0)
        }
        favViewC.view.alpha = 0.0
        
        searchViewC = SearchViewController()
        self.view.addSubview(searchViewC.view)
        
        searchViewC.view.snp_makeConstraints { (make) -> Void in
            make.top.right.left.bottom.equalTo(0)
        }
        
        
        
        navigator = UIView(frame: .zero)
        self.view.addSubview(navigator)
        navigator.snp_makeConstraints { (make) -> Void in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(70)
        }
       

        
        searchButton = UIButton(type: .Custom)
        searchButton.setImage(UIImage(named: "searchtab"), forState: .Normal)
        searchButton.setImage(UIImage(named: "searchtabselected"), forState: .Selected)
        searchButton.tag = 0
        navigator.addSubview(searchButton)
        
        searchButton.snp_makeConstraints { (make) -> Void in
            make.height.width.equalTo(50)
            make.right.equalTo(-50)
            make.centerY.equalTo(self.navigator.snp_centerY)
        }
        
        favButton = UIButton(type: .Custom)
        
        favButton.setImage(UIImage(named: "favtab"), forState: .Normal)
        favButton.setImage(UIImage(named: "favtabselected"), forState: .Selected)
        navigator.addSubview(favButton)
        favButton.tag = 1
        favButton.snp_makeConstraints { (make) -> Void in
            make.height.width.equalTo(50)
            make.left.equalTo(50)
            make.centerY.equalTo(self.navigator.snp_centerY)
        }
        
        favButton.addTarget(self, action: "switchTabs:", forControlEvents: .TouchUpInside)
        searchButton.addTarget(self, action: "switchTabs:", forControlEvents: .TouchUpInside)
        showHide(0)
    }

    func switchTabs(sender : UIButton){
        showHide(sender.tag)
    }
    
    func showHide(tag : Int){
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.searchViewC.view.transform = tag == 0 ? CGAffineTransformIdentity : CGAffineTransformMakeScale(0.7, 0.7)
            self.searchViewC.view.alpha = tag == 0 ? 1.0 : 0.0
            self.favViewC.view.transform = tag == 0 ? CGAffineTransformMakeScale(0.7, 0.7) : CGAffineTransformIdentity
            self.favViewC.view.alpha = tag == 0 ? 0.0 : 1.0
            }) { (fin) -> Void in
                self.searchButton.selected = tag == 0 ? true : false
                self.favButton.selected = tag == 0 ? false : true
                self.favViewC.view.hidden = tag == 0
                self.searchViewC.view.hidden = tag != 0
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
