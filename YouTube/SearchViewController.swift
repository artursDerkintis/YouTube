//
//  SearchViewController.swift
//  YouTube
//
//  Created by Arturs Derkintis on 12/30/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

let videoNotification = "videoNotify"
let subUpdate = "subsUpdate"
let channelNotification = "channelNotify"

protocol ChannelTitleDelegate{
    func openChannelForCell(cell : VideoCell)
}

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, SuggestionDelegate, ChannelTitleDelegate {
    var collectionView : UICollectionView!
    
    var provider = SearchResultsProvider()
    let collectionViewLayout = SpringyFlowLayout()
    
    
    var items : [Item]?{
        didSet{
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                
                self.collectionView.reloadData()
                self.collectionViewLayout.setup()
            }
        }
    }
    
    var searchField : UITextField!
    var lastContentOffset = CGFloat(0)
    
    var currentSearch = ""
    var pageToken : String?
    
    var suggestionTable : SuggestionsTableViewController!
    
    var activityInd: NVActivityIndicatorView!
    var buttomLoader : NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewLayout.setup()
        collectionViewLayout.itemSize = CGSize(width: 250, height: 165)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.registerClass(ChannelCell.self, forCellWithReuseIdentifier: "Channel")
        collectionView.registerClass(VideoCell.self, forCellWithReuseIdentifier: "Video")
        collectionView.backgroundColor = UIColor.clearColor()
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 64, right: 0)
        collectionView.delegate = self
        collectionView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.right.left.bottom.equalTo(0)
        }
        buttomLoader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: NVActivityIndicatorType.BallScaleRippleMultiple, color: .whiteColor(), size: CGSize(width: 20, height: 20))
        view.addSubview(buttomLoader)
        buttomLoader.hidesWhenStopped = true
        buttomLoader.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view.snp_centerX)
            make.bottom.equalTo(10)
            make.height.equalTo(64)
        }
        
        searchField = UITextField(frame: .zero)
        view.addSubview(searchField)
        searchField.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(15)
            make.right.equalTo(-15)
            make.left.equalTo(15)
            make.height.equalTo(38)
        }
        searchField.layer.cornerRadius = 2.5
        searchField.backgroundColor = .whiteColor()
        let searchImage = UIImageView(image: UIImage(named: "search"))
        searchImage.contentMode = .ScaleToFill
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        searchImage.frame = CGRect(x: 9, y: 9, width: 20, height: 20)
        leftView.addSubview(searchImage)
        searchField.leftView = leftView
        searchField.tintColor = UIColor.grayColor()
        searchField.leftViewMode = .Always
        searchField.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        searchField.placeholder = "Search"
        searchField.addTarget(self, action: "textEnter:", forControlEvents: .EditingDidEndOnExit)
        searchField.addTarget(self, action: "textDidStart:", forControlEvents: .EditingDidBegin)
        searchField.addTarget(self, action: "textDidChange:", forControlEvents: .EditingChanged)
        searchField.addTarget(self, action: "textDidEnd", forControlEvents: .EditingDidEnd)
        
        
        suggestionTable = SuggestionsTableViewController()
        view.addSubview(suggestionTable.view)
        suggestionTable.view.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(53)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(self.view.snp_height)
        }
        suggestionTable.delegate = self
        showHideSuggs(true)
        activityInd = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .BallSpinFadeLoader, color: .whiteColor(), size: CGSize(width: 30, height: 30))
        view.addSubview(activityInd)
        activityInd.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view.snp_centerX)
            make.centerY.equalTo(self.view.snp_centerY)
        }
        activityInd.hidesWhenStopped = true
        
    }
    private var loadingmore : Bool = false{
        didSet{
            loadingmore ? buttomLoader.startAnimation() : buttomLoader.stopAnimation()
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
    
    func getSearchResults(string : String){
        
        provider.getSearchResults(string, pageToken: pageToken) { (nextPageToken, items) -> Void in
            
            self.loading = false
            self.loadingmore = false
            
            if self.pageToken == nil{
                self.items = items.filter({ (item) -> Bool in
                    if item.type != .None{
                        return true
                    }else{
                        return false
                    }
                })
            }else{
                if self.items != nil{
                    self.items! += items.filter({ (item) -> Bool in
                        if item.type != .None{
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
    
    func textDidStart(textField : UITextField){
        showHideSuggs(false)
    }
    
    func textDidChange(textField : UITextField){
        if textField.text?.characters.count > 0{
            suggestionTable.getSearchResults(textField.text!)
        }
    }
    func textDidEnd(){
        showHideSuggs(true)
    }
    
    func textEnter(textField : UITextField){
        if textField.text?.characters.count > 0{
            newSearch(textField.text!)
        }
    }
    func newSearch(string : String){
        loading = true
        searchField.text = string
        searchField.endEditing(true)
        self.pageToken = nil
        currentSearch = string
        self.items?.removeAll()
        self.items = nil
        getSearchResults(string)
        showHideSuggs(true)
    }
    
    func putTextOnSearchField(string : String){
        searchField.text = string
    }
    
    func showHideSuggs(hide : Bool){
        if hide{
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.suggestionTable.view.alpha = 0.0
                self.collectionView.alpha = 1.0
                }, completion: { (fin) -> Void in
                    self.suggestionTable.view.hidden = true
            })
        }else{
            self.suggestionTable.view.hidden = false
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.suggestionTable.view.alpha = 1.0
                self.collectionView.alpha = 0.0
                }, completion: { (fin) -> Void in
                    
            })
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let item = items?[indexPath.row]{
            switch item.type{
            case .Video:
                let videoCell = collectionView.dequeueReusableCellWithReuseIdentifier("Video", forIndexPath: indexPath) as! VideoCell
                //videoCell.channelTitleLabel.text = item.video?.channelTitle
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
                videoCell.channelTitleDelgate = self
                return videoCell
                
            case .Channel:
                let channelCell = collectionView.dequeueReusableCellWithReuseIdentifier("Channel", forIndexPath: indexPath) as! ChannelCell
                
                if let title = item.channel?.channelDetails?.title{
                    channelCell.channelTitleLabel.text = title
                }else{
                    channelCell.channelTitleLabel.text = " "
                }
                
                ImageDownloader.sharedInstance.getImageAtURL(item.channel?.channelDetails?.thumbnail, completion: { (image) -> Void in
                    channelCell.thumbnailImageView.image = image
                })
                
                if let count = item.channel?.channelDetails?.shortSubscriberCount{
                    channelCell.subscriberCountLabel.text = "\(count) subscribers"
                }else{
                    channelCell.subscriberCountLabel.text = " "
                }
                return channelCell
                
            default:
                break
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            //reach bottom
            getSearchResults(currentSearch)
            loadingmore = true
        }
        
        if (scrollView.contentOffset.y < 0){
            //reach top
        }
        
        if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
            //not top and not bottom
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItemAtIndexPath(indexPath)?.performFadeAnimation()
        if let item = self.items?[indexPath.row] where item.type == .Video{
            NSNotificationCenter.defaultCenter().postNotificationName(videoNotification, object: item.video!)
        }else if let item = self.items?[indexPath.row] where item.type == .Channel{
            NSNotificationCenter.defaultCenter().postNotificationName(channelNotification, object: item.channel!)
        }
    }
    
    func openChannelForCell(cell: VideoCell) {
        if let row = self.collectionView.indexPathForCell(cell)?.row{
            if let item = self.items?[row]{
                let mockupChannel = Channel()
                let mockupChannelDetails = ChannelDetails()
                mockupChannelDetails.id = item.video?.videoDetails?.channelId
                mockupChannel.channelDetails = mockupChannelDetails
                NSNotificationCenter.defaultCenter().postNotificationName(channelNotification, object: mockupChannel)
            }
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

struct Number {
    static let formatterWithSepator: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .DecimalStyle
        return formatter
    }()
}
extension IntegerType {
    var stringFormatedWithSepator: String {
        return Number.formatterWithSepator.stringFromNumber(hashValue) ?? ""
    }
}

public func randRange (lower: Int , upper: Int) -> Int {
    return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
}