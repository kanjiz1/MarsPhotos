//
//  MainViewController.swift
//  MarsPhotos
//
//  Created by Oforkanji Odekpe on 6/26/20.
//  Copyright © 2020 Oforkanji Odekpe. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class MainViewController: UIViewController {
    
    let viewModel: ViewModel
    private lazy var refreshRelay = PublishRelay<Bool>()
    private lazy var disposeBag = DisposeBag()
    private lazy var refresher = UIRefreshControl()
    
    init() {
        viewModel = ViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        let pullToRefresh = refresher.rx.controlEvent(.valueChanged).asDriver().map { _ in return true }
        
        let inputs = ViewModel.Inputs(refresh:  Driver.merge(pullToRefresh, refreshRelay.asDriver(onErrorJustReturn: true)))
        
        let outputs = viewModel.getData(inputs: inputs)
        
        outputs.data.drive(onNext: { data in
            print(data)
            }).disposed(by: disposeBag)
        
        refreshRelay.accept(true)
    }
}
