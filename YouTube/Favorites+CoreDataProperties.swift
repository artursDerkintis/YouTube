//
//  Favorites+CoreDataProperties.swift
//  YouTube
//
//  Created by Arturs Derkintis on 2/1/16.
//  Copyright © 2016 Starfly. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Favorites {

    @NSManaged var id: String?
    @NSManaged var title: String?
    @NSManaged var imageUrl: String?
    @NSManaged var channelID: String?
    @NSManaged var channelTitle: String?
    @NSManaged var duration: String?
    
}
