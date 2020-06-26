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
    enum Error: Swift.Error {
           case failed
    }

   static func request(with path: String) -> URLRequest {
       guard let url = URL(string: path) else {
           fatalError("Unable to get URL")
       }

       var request = URLRequest(url: url)
       request.httpMethod = "GET"
       return request
   }
   
   static func request() -> Observable<MarsPhoto> {
    let path = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&page=2&api_key=DEMO_KEY"

       return Observable.create { observer -> Disposable in
        let request = self.request(with: path)
           
           let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let response = response as? HTTPURLResponse, (200...399).contains(response.statusCode) {
                    do {
                        let data = try JSONDecoder().decode(MarsPhoto.self, from: data ?? Data())
                        observer.onNext(data)
                    } catch let error {
                        observer.onError(error)
                    }
                } else {
                    observer.onError(Error.failed)
                }
            
            observer.onCompleted()
           }
           
           task.resume()

           return Disposables.create()
       }
   }
}
