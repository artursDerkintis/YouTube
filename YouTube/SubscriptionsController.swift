//
//  SubscriptionsController.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/25/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit

import NVActivityIndicatorView

class SubscriptionsController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    var subscriptions : [Subscription]? {
        didSet{
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.collectionView.reloadData()
            }
        }
    }
    
    var browserDelegate : BrowserDelegate?
    
    var collectionView : UICollectionView!
    
    var bigCollectionViewLayout = UICollectionViewFlowLayout()
    var smallCollectionViewLayout = UICollectionViewFlowLayout()
    var activityInd: NVActivityIndicatorView!
    let subs = SubscriptionsProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bigCollectionViewLayout.itemSize = CGSize(width: 100, height: 100)
        bigCollectionViewLayout.minimumLineSpacing = 40
        
        smallCollectionViewLayout.itemSize = CGSize(width: 60, height: 60)
        smallCollectionViewLayout.minimumLineSpacing = 40
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: bigCollectionViewLayout)
        collectionView.dataSource = self
        collectionView.delegate  = self
        collectionView.registerClass(SubscriptionsCell.self, forCellWithReuseIdentifier: "Subs")
        collectionView.backgroundColor = .clearColor()
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        collectionView.snp_makeConstraints { (make) -> Void in
            make.top.left.right.bottom.equalTo(0)
        }
        collectionView.contentInset = UIEdgeInsetsMake(75, 25, 64, 25)
        UserHandler.sharedInstance.addObserver(self, forKeyPath: "loaded", options: .New, context: nil)
        activityInd = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .BallSpinFadeLoader, color: .whiteColor(), size: CGSize(width: 30, height: 30))
        view.addSubview(activityInd)
        activityInd.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view.snp_centerX)
            make.centerY.equalTo(self.view.snp_centerY)
        }
        activityInd.hidesWhenStopped = true
        loading = true
        NSNotificationCenter.defaultCenter().addObserverForName(subUpdate, object: nil, queue: nil) { (not) -> Void in
            self.getChannelsInitially()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UIView.animateWithDuration(0.3) { () -> Void in
            self.collectionView.contentInset = UIEdgeInsetsMake(75, self.view.frame.width * 0.07, 64, self.view.frame.width * 0.07)
        }
        
    }
    
    private var loading : Bool = false{
        didSet{
            loading ? activityInd.startAnimation() : activityInd.stopAnimation()
            UIView.animateWithDuration(0.3) { () -> Void in
                self.collectionView.alpha = self.loading ? 0.0 : 1.0
            }
        }
    }

    
    func setSmallLayout(){
        self.collectionView.performBatchUpdates({ () -> Void in
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.setCollectionViewLayout(self.smallCollectionViewLayout, animated: true)
            }) { (i) -> Void in
                
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "loaded"{
            getChannelsInitially()
            browserDelegate?.setOwnInfo()
        }
    }
    func getChannelsInitially(){
        
        if let token = currentUser.token{
            subs.getMySubscribedChannels(token, completion: { (subscriptions) -> Void in
                self.subscriptions = subscriptions
                self.loading = false
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let sub = subscriptions?[indexPath.row]{
            browserDelegate?.loadSubscription(sub.channelId!)
            delay(0.3, closure: { () -> () in
                collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
            })
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Subs", forIndexPath: indexPath) as! SubscriptionsCell
        if let sub = subscriptions?[indexPath.row]{
            cell.channelTitleLabel.text = sub.title
            ImageDownloader.sharedInstance.getImageAtURL(sub.thumbnail, completion: { (image) -> Void in
                cell.thumbnailImage.image = image
            })
            if let newCount = sub.newItemCount where Int(newCount) > 0{
                cell.newItemsWarningView.hidden = false
                cell.circleView.hidden = false
                cell.newItemsWarningLabel.text = Int(newCount) < 100 ? newCount : "99+"
            }else{
                cell.circleView.hidden = true
                cell.newItemsWarningView.hidden = true
            }
        }else{
            cell.channelTitleLabel.text = ""
            cell.newItemsWarningView.hidden = true
            cell.circleView.hidden = true
            cell.thumbnailImage.image = nil
        }
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subscriptions?.count ?? 0
    }
}
