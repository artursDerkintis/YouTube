//
//  ChannelsViewController.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/30/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit

class ChannelsViewController: UINavigationController {
    
    var channelViewControllers = [ChannelViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    func addChannelController(channel : Channel){
        let channelVC = ChannelViewController()
        channelVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        channelVC.modalTransitionStyle = .CrossDissolve
        let last = channelViewControllers.last ?? self
        last.presentViewController(channelVC, animated: true, completion: nil)
        if let lasty = last as? ChannelViewController{
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                lasty.collectionView.alpha = 0.0
                lasty.collectionView.transform = CGAffineTransformMakeScale(0.7, 0.7)
            })
        }
        self.channelViewControllers.append(channelVC)
        channelVC.pageToken = nil
        channelVC.loadVideosForChannel(channel.channelDetails!.id!)
        
        
    }
    
    func removeCurrentChannelController(){
        if let lastVC = channelViewControllers.last{
            channelViewControllers.removeLast()
            lastVC.dismissViewControllerAnimated(true, completion: nil)
            if let last = channelViewControllers.last{
               UIView.animateWithDuration(0.3, animations: { () -> Void in
                    last.collectionView.alpha = 1.0
                    last.collectionView.transform = CGAffineTransformIdentity
               })
            }
        }
    }
    
    func removeAll(){
        for vc in channelViewControllers{
            vc.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
