//
//  Photo+CoreDataProperties.swift
//  
//
//  Created by Oforkanji Odekpe on 6/26/20.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "PhotoFromMars")
    }

    @NSManaged public var roverName: String?
    @NSManaged public var photo: Data?

}
