//
//  DescriptionController.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/8/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit

class DescriptionController: UIViewController {
    
    var titleView : TitleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView = TitleView(frame: .zero)
        view.addSubview(titleView)
        titleView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(38)
            make.right.equalTo(-38)
            make.left.equalTo(38)
            make.height.equalTo(100)
        }
    }
    
    func loadVideoDetails(video : Video){
        if let videoDetails = video.videoDetails{
            print(videoDetails.videoDescription)
            titleView.titleLabel.text = videoDetails.title
            if let views = Int(videoDetails.viewCount!)?.stringFormatedWithSepator, published = video.videoDetails?.publishedAtFormated{
                titleView.viewsCountLabel.text = views + " views" + " • " + "Published on \(published)"
            }
            if let imageAdress = video.channel?.thumbnail{
                ImageDownloader.sharedInstance.getImageAtURL(imageAdress, completion: { (image) -> Void in
                    self.titleView.channelImageView.image = image
                })
            }
            if let channelTitle = video.channel?.title, subsCount = video.channel?.subscriberCount{
                if let subsribersCount = Int(subsCount){
                    titleView.channelTitleLabel.text = channelTitle + " • " + subsribersCount.stringFormatedWithSepator + " subscribers"
                }
            }
        }
    }
    func clearAll(){
        titleView.channelImageView.image = nil
        titleView.channelTitleLabel.text = ""
        titleView.viewsCountLabel.text = ""
        titleView.titleLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
