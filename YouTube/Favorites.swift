//
//  Favorites.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/4/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import Foundation
import CoreData


class Favorites: NSManagedObject {
    
    
// Insert code here to add functionality to your managed object subclass
    
    lazy var durationFormated : String = {
        if let duration = self.duration{
            return parseDuration(duration)
        }
        return ""
    }()

}
