//
//  MarsDatabaseHelper.swift
//  MarsPhotos
//
//  Created by Oforkanji Odekpe on 6/26/20.
//  Copyright © 2020 Oforkanji Odekpe. All rights reserved.
//

import UIKit
import CoreData

final class MarsDatabaseHelper {
    static let instance = MarsDatabaseHelper()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save(imageData: Data, name: String) {
        let dataInstance = Photo(context: context)
        
        dataInstance.photo = imageData
        dataInstance.roverName = name
        
        do {
                try context.save()
                print("Data is saved")
        } catch {
                print(error.localizedDescription)
        }
    }
    
    func fetch() -> [Photo] {
        var data = [Photo]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        do {
            data = try context.fetch(fetch) as? [Photo] ?? []
        } catch {
            print("Error while fetching the image")
        }
        
        return data
    }
}
