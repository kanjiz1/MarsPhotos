//
//  NetworkSession.swift
//  MarsPhotos
//
//  Created by Oforkanji Odekpe on 6/26/20.
//  Copyright © 2020 Oforkanji Odekpe. All rights reserved.
//

import RxSwift
import RxCocoa

final class NetworkSession {
    enum Error: Swift.Error {
            case failed
     }

    private func request(with path: String) -> URLRequest {
        guard let url = URL(string: path) else {
            fatalError("Unable to get URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    func request<T>(path: String) -> Observable<T> where T: Decodable {

        return Observable.create { observer -> Disposable in
         let request = self.request(with: path)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                 if let response = response as? HTTPURLResponse, (200...399).contains(response.statusCode) {
                     do {
                         let data = try JSONDecoder().decode(T.self, from: data ?? Data())
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
