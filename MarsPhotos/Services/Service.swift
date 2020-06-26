//
//  Service.swift
//  MarsPhotos
//
//  Created by Oforkanji Odekpe on 6/25/20.
//  Copyright © 2020 Oforkanji Odekpe. All rights reserved.
//

import RxSwift
import RxCocoa

final class Service {
    private let networkSession: NetworkSession
    
    init() {
        networkSession = NetworkSession()
    }
    
    func getData() -> Observable<MarsPhoto> {
        let path = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&page=2&api_key=DEMO_KEY"
        return networkSession.request(path: path)
    }
    
}
