//
//  Service.swift
//  MarsPhotos
//
//  Created by Oforkanji Odekpe on 6/25/20.
//  Copyright © 2020 Oforkanji Odekpe. All rights reserved.
//

import RxSwift
import RxCocoa

protocol PhotoService {
    func getMarsPhotos(pageNumber: Int) -> Single<[MarsPhoto]>
}

final class Service: PhotoService {
    
    let url = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&page=2&api_key=DEMO_KEY"
    
    func getMarsPhotos(pageNumber: Int) -> Single<[MarsPhoto]> {
        return .just([])
    }
}
