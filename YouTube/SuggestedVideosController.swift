//
//  SuggestedVideosController.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/9/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit

class SuggestedVideosController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var videos : [Video]?{
        didSet{
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                
                self.collectionView.reloadData()
                
                self.collectionViewLayout.setup()
            }

        }
    }
    let collectionViewLayout = SpringyFlowLayout()
    var collectionView : UICollectionView!
    
    let provider = SuggestedVideosProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewLayout.setup()
        collectionViewLayout.itemSize = CGSize(width: 205, height: 120)
        collectionViewLayout.scrollDirection = .Horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(SmallVideoCell.self, forCellWithReuseIdentifier: "Video")
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 38)
        // collectionView.delegate = self
        collectionView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.right.left.bottom.equalTo(0)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let videoCell = collectionView.dequeueReusableCellWithReuseIdentifier("Video", forIndexPath: indexPath) as! SmallVideoCell
        let video = videos?[indexPath.row]
        if let thumbnail = video?.videoDetails?.thumbnail{
            ImageDownloader.sharedInstance.getImageAtURL(thumbnail, completion: { (image) -> Void in
                videoCell.thumbnailImageView.image = image
            })
        }
        if let title = video?.videoDetails?.title{
            videoCell.videoTitleLabel.text = title
        }
        if let title = video?.videoDetails?.channelTitle{
            videoCell.channelTitleLabel.text = "  " + title
        }
        
        if let duration = video?.videoDetails?.durationFormated{
            videoCell.durationLabel.text = "  \(duration)  "
            videoCell.setDurationLabelSize()
        }
        if let views = video?.videoDetails?.shortViewCount{
            videoCell.viewsCountLabel.text = views
        }
        return videoCell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItemAtIndexPath(indexPath)?.performFadeAnimation()
        NSNotificationCenter.defaultCenter().postNotificationName(videoNotification, object: self.videos![indexPath.row])
    }
    
    
    func getSuggestions(id : String){
        self.videos?.removeAll()
        provider.getSuggestionsForID(id) { (videos) -> Void in
            self.videos = videos
        }
    }
    
}

