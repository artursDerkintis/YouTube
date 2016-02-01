//
//  ImageDownloader.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/21/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit
import Alamofire

class ImageDownloader: NSObject {
    private var images = Dictionary<String, UIImage>()
    private override init() {}
    static let sharedInstance = ImageDownloader()
    
    func getImageAtURL(url : String?, completion:(image : UIImage) -> Void){
        if let url = url{
            if let cachedImage = images[url]{
                completion(image: cachedImage)
            }else{
                self.getImageForAddress(url, completion: completion)
            }
        }
    }
    
    private func getImageForAddress(imageAddress : String, completion:(image : UIImage) -> Void){
        Alamofire.request(.GET, imageAddress).response { (_, _, data, error) -> Void in
            if let data = data{
                if let image = UIImage(data: data){
                    completion(image: image)
                    self.images[imageAddress] = image
                }
            }
        }
    }
    
}

