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
        let data: Driver<MarsPhoto>
    }
    
    func getData(inputs: Inputs) -> Outputs {
        
        let data = inputs.refresh.flatMap { _ in Service().getData().materialize().asDriver(onErrorJustReturn: Event<MarsPhoto>.completed)
        }
        
        let dataDriver = data.filter { !$0.isCompleted }.map { data -> MarsPhoto in
            var photos: MarsPhoto = MarsPhoto(photos: [])
            switch data {
            case .next(let photoData):
                photos = photoData
            default:
                break
            }
            
            return photos
        }
        
        return Outputs(data: dataDriver)
    }
}
