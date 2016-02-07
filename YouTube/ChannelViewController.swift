//
//  ChannelViewController.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/27/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ChannelViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    private var items : [Item]? {
        didSet{
            delay(0.31) { () -> () in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.collectionView.reloadData()
                    self.collectionViewLayout.setup()
                    self.loading = false
                }
            }
        }
    }
    var pageToken : String?
    var collectionView : UICollectionView!
    
    private let collectionViewLayout = SpringyFlowLayout()
    private let provider = ChannelProvider()
    
    private var activityInd: NVActivityIndicatorView!
    private var buttomLoader : NVActivityIndicatorView!

    private var currentChannelId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewLayout.setup()
        collectionViewLayout.itemSize = CGSize(width: 230, height: 150)
        collectionViewLayout.minimumLineSpacing = 10
        // Do any additional setup after loading the view.
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.dataSource = self
        collectionView.delegate  = self
        collectionView.registerClass(VideoCell.self, forCellWithReuseIdentifier: "VidCell")
        collectionView.backgroundColor = .clearColor()
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        collectionView.snp_makeConstraints { (make) -> Void in
            make.top.left.right.bottom.equalTo(0)
        }
        collectionView.contentInset = UIEdgeInsetsMake(64, 25, 64, 25)
        activityInd = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .BallSpinFadeLoader, color: .whiteColor(), size: CGSize(width: 30, height: 30))
        view.addSubview(activityInd)
        activityInd.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view.snp_centerX)
            make.centerY.equalTo(self.view.snp_centerY)
        }
        activityInd.hidesWhenStopped = true
        buttomLoader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: NVActivityIndicatorType.BallScaleRippleMultiple, color: .whiteColor(), size: CGSize(width: 20, height: 20))
        view.addSubview(buttomLoader)
        buttomLoader.hidesWhenStopped = true
        buttomLoader.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view.snp_centerX)
            make.bottom.equalTo(10)
            make.height.equalTo(64)
        }

      
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private var loadingmore : Bool = false{
        didSet{
            loadingmore ? buttomLoader.startAnimation() : buttomLoader.stopAnimation()
        }
    }
    
    var loading : Bool = false{
        didSet{
            loading ? activityInd.startAnimation() : activityInd.stopAnimation()
            UIView.animateWithDuration(0.3) { () -> Void in
                self.collectionView.alpha = self.loading ? 0.0 : 1.0
            }
        }
    }
    
    
    func loadVideosForChannel(id: String){
        self.currentChannelId = id
        let accesToken = currentUser.token
        provider.getVideosOfChannel(id, accessToken: accesToken, pageToken: pageToken) { (nextPageToken, items) -> Void in
            self.loading = false
            self.loadingmore = false
            if self.pageToken == nil{
                self.items = items.filter({ (item) -> Bool in
                    if item.type == .Video{
                        return true
                    }else{
                        return false
                    }
                })
            }else{
                if self.items != nil{
                    self.items! += items.filter({ (item) -> Bool in
                        if item.type == .Video{
                            return true
                        }else{
                            return false
                        }
                    })
                    
                }
            }
            self.pageToken = nextPageToken
        }
        
    }
    
    
    
   
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            //reach bottom
            loadingmore = true
            loadVideosForChannel(self.currentChannelId ?? "")
        }
        
        if (scrollView.contentOffset.y < 0){
            //reach top
        }
        
        if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
            //not top and not bottom
           
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let videoCell = collectionView.dequeueReusableCellWithReuseIdentifier("VidCell", forIndexPath: indexPath) as! VideoCell
        if let item = items?[indexPath.row] where item.type == .Video{
         
            ImageDownloader.sharedInstance.getImageAtURL(item.video?.videoDetails?.thumbnail, completion: { (image) -> Void in
                videoCell.thumbnailImageView.image = image
            })
            
            if let title = item.video?.videoDetails?.title{
                videoCell.videoTitleLabel.text = title
            }
            
            if let title = item.video?.videoDetails?.channelTitle{
                videoCell.channelTitleLabel.text = "  " + title
            }
            
            if let duration = item.video?.videoDetails?.durationFormated{
                videoCell.durationLabel.text = "  \(duration)  "
                videoCell.setDurationLabelSize()
            }
            
            if let views = item.video?.videoDetails?.shortViewCount{
                videoCell.viewsCountLabel.text = views
            }
           
        }
        return videoCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSNotificationCenter.defaultCenter().postNotificationName(videoNotification, object: self.items![indexPath.row].video!)
    }
    
}


public func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}