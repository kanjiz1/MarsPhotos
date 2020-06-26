//
//  ViewModel.swift
//  MarsPhotos
//
//  Created by Oforkanji Odekpe on 6/26/20.
//  Copyright © 2020 Oforkanji Odekpe. All rights reserved.
//

import RxSwift
import RxCocoa

final class ViewModel {
    
    struct Inputs {
        let refresh: Driver<Bool>
    }
    
    struct Outputs {
        let dataSource: Driver<NSDiffableDataSourceSnapshot<MainViewController.Section, MainViewController.Item>>
    }
    
    func getData(inputs: Inputs) -> Outputs {
        
        let data = inputs.refresh.flatMap { _ in Service().getData().materialize().asDriver(onErrorJustReturn: Event<MarsPhoto>.completed)
        }
        
        let dataSource = data.filter { !$0.isCompleted }.map { data -> NSDiffableDataSourceSnapshot<MainViewController.Section, MainViewController.Item> in
            var datasource = NSDiffableDataSourceSnapshot<MainViewController.Section, MainViewController.Item>()
            switch data {
            case .next(let photoData):
                datasource.appendSections([.main])
                photoData.photos.forEach { photo in
                    datasource.appendItems([.main((photo))], toSection: .main)
                }
            default:
                break
            }
            
            return datasource
        }
        
        return Outputs(dataSource: dataSource)
    }
}

extension UIImageView {

    private var imageCache: NSCache<NSString, UIImage> {
        let cache = NSCache<NSString, UIImage>()
        return cache
    }

    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        self.image = nil

        let imageServerUrl = URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        

        if let cachedImage = imageCache.object(forKey: NSString(string: imageServerUrl)) {
            self.image = cachedImage
            return
        }

        guard let url = URL(string: imageServerUrl) else {
            return
        }
        
        /// I noticed the url from the api is not secure
        /// this caused some issues with App Transport security
        /// So I had to change the scheme to load images
        var comps = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        comps.scheme = "https"
        
        if let https = comps.url {
            URLSession.shared.dataTask(with: https, completionHandler: { (data, response, error) in
                if error != nil {
                    print("Error occured: \(error!)")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            self.imageCache.setObject(downloadedImage, forKey: NSString(string: imageServerUrl))
                            self.image = downloadedImage
                        }
                    }
            }
            }).resume()
        }
    }
}
