//
//  Model.swift
//  MarsPhotos
//
//  Created by Oforkanji Odekpe on 6/25/20.
//  Copyright © 2020 Oforkanji Odekpe. All rights reserved.
//

import Foundation

struct MarsPhoto: Decodable {
    let id: Int
    let sol: Int
    let camera: Camera
    let img_src: String
    let earth_date: String
    let rover: Rover
    
    struct Camera: Decodable {
        let id: Int
        let name: String
        let rover_id: Int
        let full_name: String
    }
    
    struct Rover: Decodable {
        let id: Int
        let name: String
        let landing_date: String
        let launch_date: String
        let status: String
    }
}
