//
//  FavoritesController.swift
//  YouTube
//
//  Created by Arturs Derkintis on 2/1/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit
import CoreData
import NVActivityIndicatorView

class FavoritesController: UIViewController, NSFetchedResultsControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView : UICollectionView!
    
    var provider = SearchResultsProvider()
    let collectionViewLayout = SpringyFlowLayout()
    
    
    var searchField : UITextField!
    var lastContentOffset = CGFloat(0)
    
    var suggestionTable : SuggestionsTableViewController!
    
    var fetchController : NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchController = NSFetchedResultsController(fetchRequest: self.request, managedObjectContext: DataHelper.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchController.delegate = self
        
        collectionViewLayout.setup()
        collectionViewLayout.itemSize = CGSize(width: 250, height: 165)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.registerClass(VideoCell.self, forCellWithReuseIdentifier: "Videoone")
        collectionView.backgroundColor = UIColor.clearColor()
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 64, right: 0)
        collectionView.delegate = self
        collectionView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.right.left.bottom.equalTo(0)
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
        searchField.placeholder = "Search in favorites(doesnt work yet)"
        //searchField.addTarget(self, action: "textEnter:", forControlEvents: .EditingDidEndOnExit)
        //searchField.addTarget(self, action: "textDidStart:", forControlEvents: .EditingDidBegin)
       // searchField.addTarget(self, action: "textDidChange:", forControlEvents: .EditingChanged)
        //searchField.addTarget(self, action: "textDidEnd", forControlEvents: .EditingDidEnd)
        loadData()
    }
    
    func loadData() {
        do {
            try fetchController?.performFetch()
            self.collectionView.reloadData()
        } catch _ {
            
        }
    }
    
    lazy var request : NSFetchRequest = {
        let fetch = NSFetchRequest(entityName: "Favorites")
        fetch.sortDescriptors = [NSSortDescriptor(key: "arrangeIndex", ascending: false)]
        return fetch
    }()
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type{
        case .Insert:
            self.collectionView.insertItemsAtIndexPaths([newIndexPath!])
            break
        case .Move:
            self.collectionView.moveItemAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
            break
        case .Delete:
            self.collectionView.deleteItemsAtIndexPaths([indexPath!])
            break
        case .Update:
            self.collectionView.reloadItemsAtIndexPaths([indexPath!])
            break
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let fav = self.fetchController.objectAtIndexPath(indexPath) as? Favorites{
            let videoCell = collectionView.dequeueReusableCellWithReuseIdentifier("Videoone", forIndexPath: indexPath) as! VideoCell
            ImageDownloader.sharedInstance.getImageAtURL(fav.imageUrl, completion: { (image) -> Void in
                videoCell.thumbnailImageView.image = image
            })
            if let title = fav.title{
                videoCell.videoTitleLabel.text = title
            }
            if let title = fav.channelTitle{
                videoCell.channelTitleLabel.text = "  " + title
            }
            
            videoCell.durationLabel.text = "  \(fav.durationFormated)  "
            videoCell.setDurationLabelSize()
            
            return videoCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
        let fav = fetchController.objectAtIndexPath(indexPath) as! Favorites
        NSNotificationCenter.defaultCenter().postNotificationName(videoNotification, object: fav)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
