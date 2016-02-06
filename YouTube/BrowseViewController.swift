//
//  BrowseViewController.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/27/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit

protocol BrowserDelegate{
    func loadSubscription(channelId : String)
    func setOwnInfo()
}

class BrowseViewController: UIViewController, BrowserDelegate {
    var subscriptionsVC : SubscriptionsController!
    var navigationView : BrowseTopView!
    var channelsVC : ChannelsViewController!
    
    var forwardSteps = [Channel]()
    
    var currentChannel : Channel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        subscriptionsVC = SubscriptionsController()
        subscriptionsVC.browserDelegate = self
        addChildViewController(subscriptionsVC)
        view.addSubview(subscriptionsVC.view)
        subscriptionsVC.view.snp_makeConstraints { (make) -> Void in
            make.top.right.bottom.equalTo(0)
            make.width.equalTo(self.view.snp_width).multipliedBy(0.98)
        }
        channelsVC = ChannelsViewController()
        view.addSubview(channelsVC.view)
        channelsVC.view.backgroundColor = UIColor.clearColor()
        channelsVC.view.snp_makeConstraints { (make) -> Void in
            make.left.top.bottom.equalTo(0)
            make.right.equalTo(self.subscriptionsVC.view.snp_leftMargin)
        }
        self.view.bringSubviewToFront(subscriptionsVC.view)
        navigationView = BrowseTopView(frame: .zero)
        view.addSubview(navigationView)
        navigationView.snp_makeConstraints { (make) -> Void in
            make.top.left.right.equalTo(0)
            make.height.equalTo(64)
        }
        
        navigationView.backButton.addTarget(self, action: "goBack", forControlEvents: .TouchDown)
        let long = UILongPressGestureRecognizer(target: self, action: "goHome")
        long.minimumPressDuration = 1.0
        navigationView.backButton.addGestureRecognizer(long)
        // Do any additional setup after loading the view.
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openChannelByNotif:", name: channelNotification, object: nil)
    }
    
    func openChannelByNotif(not : NSNotification){
        if let id = (not.object as? Channel)?.channelDetails?.id{
            self.loadSubscription(id)
        }
    }
    
    func goHome(){
        channelsVC.removeAll()
        self.setOwnInfo()
        self.subscriptionsVC.view.snp_updateConstraints { (make) -> Void in
            make.width.equalTo(self.view.snp_width)
        }
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    func goBack(){
        if channelsVC.channelViewControllers.count > 1{
            channelsVC.removeCurrentChannelController()
        }else{
            channelsVC.removeCurrentChannelController()
            self.setOwnInfo()
            self.subscriptionsVC.view.snp_updateConstraints { (make) -> Void in
                make.width.equalTo(self.view.snp_width).multipliedBy(0.97)
            }
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.view.layoutIfNeeded()
                }, completion: { (fin) -> Void in
            })
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tap(sender : UITapGestureRecognizer){
        if sender.state == .Ended{
            
        }
    }
    
    func setOwnInfo(){
        navigationView.setDetails(currentUser.name!, thumbnail: currentUser.imageURL!, description: "", subscribed: Subscribed.Unknown)
        navigationView.backButton.hidden = true
        
    }
    func setChannelInfo(){
        if let cdet = currentChannel.channelDetails, subscribed = currentChannel.subscribed {
            self.navigationView.setDetails(cdet.title!, thumbnail: cdet.thumbnail!, description: "\(cdet.shortSubscriberCount) subscribers", subscribed: subscribed ? Subscribed.Subscribed : Subscribed.NotSubscribed)
            self.navigationView.backButton.hidden = false
            self.navigationView.currentChannelId = cdet.id
        }
    }
    func loadSubscription(channelId : String){
        let channel = Channel()
        channel.getChannelDetails(channelId) { (channelDetails) -> Void in
            channel.channelDetails = channelDetails
            haveISubscribedToChannel(channelId, token: currentUser.token!, completion: { (fin) -> Void in
                channel.subscribed = fin
                self.currentChannel = channel
                self.forwardSteps.append(self.currentChannel)
                self.setChannelInfo()
                self.openChannel(self.currentChannel)
            })
            
        }
        
    }
    
    func openChannel(channel: Channel) {
        minimizeSubscriptions()
        channelsVC.addChannelController(channel)
    }
    
    func minimizeSubscriptions(){
        self.subscriptionsVC.view.snp_updateConstraints { (make) -> Void in
            make.width.equalTo(self.view.snp_width).dividedBy(4.2)
        }
        
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.layoutIfNeeded()
            self.subscriptionsVC.collectionView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 64, right: 0)
        }
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