//
//  VideoController.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/4/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import JavaScriptCore
import XCDYouTubeKit
import AVKit
import SwiftyUserDefaults

class VideoController: UIViewController{
    var contentView : VideoView!
    
    var playerView : PlayerView!
    
    var controlView : ControlView!
    
    var pictureInPictureController: AVPictureInPictureController!
    
    
    
    var timer : NSTimer?
    var canceled = false
    
    var timeObserverToken: AnyObject?
    
    var activityInd : NVActivityIndicatorView!
    
    lazy var player = AVPlayer()
    
    var videoQualityHD : Bool = Defaults.boolForKey("quality")
        {
        didSet{
            Defaults.setBool(videoQualityHD, forKey: "quality")
            self.loadVideo()
        }
    }
    var possibleQualities = Dictionary<UInt, NSURL>()
    
    var delegate : VideoDelegate?
    
    var playerItem: AVPlayerItem? = nil {
        didSet {
            /*
            If needed, configure player item here before associating it with a player
            (example: adding outputs, setting text style rules, selecting media options)
            */
            player.replaceCurrentItemWithPlayerItem(playerItem)
            
            if playerItem == nil {
                cleanUpPlayerPeriodicTimeObserver()
            }
            else {
                setupPlayerPeriodicTimeObserver()
            }
        }
    }
    var videoDetails : VideoDetails?
    
    var progressBar : ProgressBar!
    var bottomPro : BottomProgress!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = VideoView()
        view.backgroundColor = .clearColor()
        
        contentView = VideoView(frame: .zero)
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.layer.shadowOffset = CGSize(width: 0.5, height: 13)
        contentView.layer.shadowOpacity = 0.17
        contentView.layer.shadowRadius = 11
        contentView.layer.shadowColor = UIColor.blackColor().CGColor
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = UIScreen.mainScreen().scale
        view.addSubview(contentView)
        
        contentView.snp_makeConstraints { (make) -> Void in
            make.top.left.equalTo(38)
            make.right.equalTo(-38)
            make.height.equalTo(self.view.snp_height).offset(-38)
        }
        
        playerView = PlayerView()
        playerView.backgroundColor = UIColor.blackColor()
        contentView.addSubview(playerView)
        playerView.snp_makeConstraints { (make) -> Void in
            make.top.left.equalTo(15)
            make.bottom.right.equalTo(-15)
        }
        
        
        
        activityInd = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .BallSpinFadeLoader, color: .whiteColor(), size: CGSize(width: 30, height: 30))
        contentView.addSubview(activityInd)
        activityInd.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(contentView.snp_centerX)
            make.centerY.equalTo(contentView.snp_centerY)
        }
        activityInd.hidesWhenStopped = true
        
        bottomPro = BottomProgress(frame: .zero)
        contentView.addSubview(bottomPro)
        bottomPro.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.right.bottom.equalTo(-15)
            make.height.equalTo(2)
        }
        
        controlView = ControlView(frame: .zero)
        contentView.addSubview(controlView)
        controlView.snp_makeConstraints { (make) -> Void in
            make.top.right.bottom.left.equalTo(0)
        }
        controlView.setButtonActions(self)
        controlView.qualityButton.selected = videoQualityHD
        
        
        progressBar = ProgressBar(frame: .zero)
        progressBar.slider.addTarget(self, action: "seek:", forControlEvents: .ValueChanged)
        controlView.addSubview(progressBar)
        progressBar.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.bottom.right.equalTo(-15)
            make.height.equalTo(50)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: "tap:")
        contentView.addGestureRecognizer(tap)
        
        addObserver(self, forKeyPath: "player.currentItem.duration", options: .New, context: nil)
        addObserver(self, forKeyPath: "player.rate", options: [.New, .Initial], context: nil)
        addObserver(self, forKeyPath: "player.currentItem.status", options: [.New, .Initial], context: nil)
        
        // Do any additional setup after loading the view.
        
        
    }
    
    
    var currentTime: Double {
        get {
            return CMTimeGetSeconds(player.currentTime())
        }
        
        set {
            let newTime = CMTimeMakeWithSeconds(newValue, 1)
            player.seekToTime(newTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        }
    }
    
    func seek(slider : Slider){
        timer?.invalidate()
        currentTime = slider.decProgress
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "player.currentItem.duration"{
            let newDuration: CMTime
            if let newDurationAsValue = change?[NSKeyValueChangeNewKey] as? NSValue {
                newDuration = newDurationAsValue.CMTimeValue
            }
            else {
                newDuration = kCMTimeZero
            }
            
            let hasValidDuration = newDuration.isNumeric && newDuration.value != 0
            let newDurationSeconds = hasValidDuration ? CMTimeGetSeconds(newDuration) : 0.0
            progressBar.slider.maxValue = Double(newDurationSeconds)
            bottomPro.maxValue = Double(newDurationSeconds)
            progressBar.duration.text = hasValidDuration ? secondsToHoursMinutesSeconds(newDurationSeconds) : "--:--"
            let currentTime = CMTimeGetSeconds(player.currentTime())
            progressBar.slider.value = hasValidDuration ? Double(currentTime / newDurationSeconds) : 0.0
            bottomPro.value = hasValidDuration ? Double(currentTime / newDurationSeconds) : 0.0
            progressBar.curentTime.text = hasValidDuration ? secondsToHoursMinutesSeconds(currentTime) : "--:--"
            controlView.hidden = !hasValidDuration
            progressBar.enabled = hasValidDuration
        }else if keyPath == "player.rate" {
            // Update playPauseButton type.
            let newRate = (change?[NSKeyValueChangeNewKey] as! NSNumber).doubleValue
            controlView.playPauseButton.tag = newRate == 0.0 ? 0 : 1
            controlView.playPauseButton.selected = newRate == 0.0 ? false : true
            if let duration = player.currentItem?.duration{
                if newRate == 0.0 && player.currentTime() == duration{
                    controlView.playPauseButton.setImage(UIImage(named: "replay"), forState: .Normal)
                    controlView.playPauseButton.tag = 909
                }
            }
        }else if keyPath == "player.currentItem.status" {
            
            let newStatus: AVPlayerItemStatus
            if let newStatusAsNumber = change?[NSKeyValueChangeNewKey] as? NSNumber {
                newStatus = AVPlayerItemStatus(rawValue: newStatusAsNumber.integerValue)!
            }
            else {
                newStatus = .Unknown
            }
            
            if newStatus == .Failed {
                
            }
            else if newStatus == .ReadyToPlay {
                //player.play()
                activityInd.stopAnimation()
                showStuff()
                if let asset = player.currentItem?.asset {
                    
                    
                    if pictureInPictureController == nil {
                        setupPictureInPicturePlayback()
                    }
                }
            }
        }
        
    }
    private func setupPlayerPeriodicTimeObserver() {
        guard timeObserverToken == nil else { return }
        
        let time = CMTimeMake(1, 10)
        
        timeObserverToken = player.addPeriodicTimeObserverForInterval(time, queue:dispatch_get_main_queue()) {
            [weak self] time in
            self?.bottomPro.value = Double(CMTimeGetSeconds(time))
            self?.progressBar.slider.value = Double(CMTimeGetSeconds(time))
            self?.progressBar.curentTime.text = secondsToHoursMinutesSeconds(CMTimeGetSeconds(time))
        }
    }
    private func cleanUpPlayerPeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        playerView.playerLayer.player = player
        //playVideo("JLf9q36UsBk")
        
    }
    
    func tap(sender : UITapGestureRecognizer){
        showStuff()
    }
    
    func changeQuality(sender: UIButton){
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "hideStuff", userInfo: nil, repeats: false)
        sender.selected = !sender.selected
        videoQualityHD = sender.selected
    }
    
    func full(sender: UIButton){
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "hideStuff", userInfo: nil, repeats: false)
        
        if let mainViewController = UIApplication.sharedApplication().delegate?.window??.rootViewController{
            if sender.tag == 0{
                sender.selected = true
                sender.tag = 1
                
                mainViewController.view.addSubview(self.contentView)
                let rect = self.view.convertRect(self.contentView.frame, toView: mainViewController.view)
                self.contentView.frame = rect
                print("\(rect), \(self.contentView.frame)")
                self.contentView.snp_updateConstraints(closure: { (make) -> Void in
                    make.top.left.right.bottom.equalTo(0)
                })
                self.playerView.snp_updateConstraints(closure: { (make) -> Void in
                    make.top.left.right.bottom.equalTo(0)
                })
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    mainViewController.view.layoutIfNeeded()
                })
                
            }else if sender.tag == 1{
                sender.selected = false
                sender.tag = 0
                self.view.superview?.bringSubviewToFront(self.view)
                self.view.addSubview(self.contentView)
                self.contentView.snp_removeConstraints()
                
                self.contentView.snp_makeConstraints(closure: { (make) -> Void in
                    make.left.equalTo(-340)
                    make.top.equalTo(0)
                    make.right.equalTo(0)
                    make.height.equalTo(self.contentView.frame.height)
                })
                self.view.layoutIfNeeded()
                
                
                
                self.contentView.snp_updateConstraints(closure: { (make) -> Void in
                    make.top.left.equalTo(38)
                    make.right.equalTo(-38)
                    make.height.equalTo(self.view.snp_height).offset(-38)
                })

                self.playerView.snp_updateConstraints { (make) -> Void in
                    make.top.left.equalTo(15)
                    make.bottom.right.equalTo(-15)
                }
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                    }, completion: { (fin) -> Void in
                        if let set = self.view.superview?.viewWithTag(90){
                            self.view.superview?.bringSubviewToFront(set)
                        }
                })
                
            }}
    }
    
    func pip(){
        if pictureInPictureController != nil{
            if pictureInPictureController.pictureInPictureActive {
                pictureInPictureController.stopPictureInPicture()
                showStuff()
            }
            else {
                hideStuff()
                pictureInPictureController.startPictureInPicture()
            }
        }
    }
    
    var operation : XCDYouTubeOperation?
    var qualities = [XCDYouTubeVideoQuality.Small240.rawValue, XCDYouTubeVideoQuality.Medium360.rawValue, XCDYouTubeVideoQuality.HD720.rawValue]
    func loadVideoWith(id : String){
        
        activityInd.startAnimation()
        hideStuff()
        operation?.cancel()
        operation = XCDYouTubeClient.defaultClient().getVideoWithIdentifier(id, completionHandler: { (video, error) -> Void in
            
            if let video = video{
                self.possibleQualities.removeAll()
                for q in self.qualities{
                    let number = NSNumber(unsignedInteger: q)
                    if let streamURL = video.streamURLs[number]{
                        self.possibleQualities[q] = streamURL
                    }
                }
                self.loadVideo()
            }
        })
    }
    
    func favorite(){
        if let det = self.videoDetails{
            DataHelper.sharedInstance.saveFavorite(det)
            delay(1.0) { () -> () in
                DataHelper.sharedInstance.favorited(det.id!) { (enabled) -> Void in
                    self.controlView.bookmarkButton.enabled = !enabled
                }
            }
        }
        
    }
    
    private func loadVideo(){
        hideStuff()
        activityInd.startAnimation()
        let currentTimeCache = currentTime
        self.controlView.qualityButton.enabled = true
        if possibleQualities[XCDYouTubeVideoQuality.Small240.rawValue] != nil && possibleQualities[XCDYouTubeVideoQuality.HD720.rawValue] == nil && possibleQualities[XCDYouTubeVideoQuality.Medium360.rawValue] == nil{
            self.controlView.qualityButton.enabled = false
            self.playerItem = AVPlayerItem(URL: possibleQualities[XCDYouTubeVideoQuality.Small240.rawValue]!)
            
        }else if possibleQualities[XCDYouTubeVideoQuality.Small240.rawValue] != nil && possibleQualities[XCDYouTubeVideoQuality.HD720.rawValue] == nil && possibleQualities[XCDYouTubeVideoQuality.Medium360.rawValue] != nil{
            
            if videoQualityHD{
                self.playerItem = AVPlayerItem(URL: possibleQualities[XCDYouTubeVideoQuality.Medium360.rawValue]!)
            }else{
                self.playerItem = AVPlayerItem(URL: possibleQualities[XCDYouTubeVideoQuality.Small240.rawValue]!)
            }
        }else if  possibleQualities[XCDYouTubeVideoQuality.Small240.rawValue] != nil && possibleQualities[XCDYouTubeVideoQuality.HD720.rawValue] != nil && possibleQualities[XCDYouTubeVideoQuality.Medium360.rawValue] != nil{
            if videoQualityHD{
                self.playerItem = AVPlayerItem(URL: possibleQualities[XCDYouTubeVideoQuality.HD720.rawValue]!)
            }else{
                self.playerItem = AVPlayerItem(URL: possibleQualities[XCDYouTubeVideoQuality.Medium360.rawValue]!)
            }
        }
        
        currentTime = currentTimeCache
    }
    private func setupPictureInPicturePlayback() {
        
        if AVPictureInPictureController.isPictureInPictureSupported() {
            pictureInPictureController = AVPictureInPictureController(playerLayer: playerView.playerLayer)
        }else {
            controlView.pipButton.enabled = false
        }
    }
    
    func showStuff(){
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.controlView.alpha = 1.0
            }) { (fin) -> Void in
        }
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "hideStuff", userInfo: nil, repeats: false)
        
    }
    func hideStuff(){
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: [UIViewAnimationOptions.BeginFromCurrentState], animations: { () -> Void in
            self.controlView.alpha = self.player.rate == 0.0 ? 1.0 : 0.0
            }, completion: nil)
        
        
    }
    
    func closeVideo(){
        player.pause()
        player.replaceCurrentItemWithPlayerItem(nil)
        currentTime = 0.0
        delegate?.hide()
        delegate?.removeDescription()
    }
    
    func playVideo(videoDetails : VideoDetails){
        
        controlView.tag = 0
        player.pause()
        player.replaceCurrentItemWithPlayerItem(nil)
        currentTime = 0.0
        controlView.playPauseButton.setImage(UIImage(named: "play"), forState: .Normal)
        loadVideoWith(videoDetails.id!)
        self.videoDetails = videoDetails
        controlView.playPauseButton.selected = false
        controlView.playPauseButton.tag = 0
        controlView.alpha = 0.0
        delegate?.show()
        
        DataHelper.sharedInstance.favorited(videoDetails.id!) { (enabled) -> Void in
            self.controlView.bookmarkButton.enabled = !enabled
        }
        
    }
    
    func play(sender : UIButton){
        timer?.invalidate()
        if sender.tag == 0{
            sender.tag = 1
            timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "hideStuff", userInfo: nil, repeats: false)
            sender.selected = true
            playerView.player?.play()
        }else if sender.tag == 1{
            sender.selected = false
            playerView.player?.pause()
            sender.tag = 0
        }else if sender.tag == 909{
            sender.tag = 1
            timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "hideStuff", userInfo: nil, repeats: false)
            let newTime = CMTimeMakeWithSeconds(0.0, 1)
            sender.setImage(UIImage(named: "play"), forState: .Normal)
            playerView.player?.seekToTime(newTime)
            playerView.player?.play()
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
