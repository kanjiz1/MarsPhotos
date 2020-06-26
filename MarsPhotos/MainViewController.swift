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

final class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    enum Section: Hashable {
        case main
    }
    
    enum Item: Hashable {
        case main(MarsPhoto.PhotoData)
    }

    private let viewModel: ViewModel
    private var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    private lazy var refreshRelay = PublishRelay<Bool>()
    private lazy var disposeBag = DisposeBag()
    private lazy var refresher = UIRefreshControl()
    
    private var collectionView: UICollectionView!
    
    init() {
        viewModel = ViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: collectionViewSize / 2, height: collectionViewSize / 2)

        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        collectionView.refreshControl = refresher
        collectionView.delegate = self
        
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ])
        
        datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: self.collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .main(let photoData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
                cell.bindTo(data: photoData)
                return cell
            }
        })
        
        let pullToRefresh = refresher.rx.controlEvent(.valueChanged).asDriver().map { _ in return true }
        
        let inputs = ViewModel.Inputs(refresh:  Driver.merge(pullToRefresh, refreshRelay.asDriver(onErrorJustReturn: true)))
        
        let outputs = viewModel.getData(inputs: inputs)
        
        outputs.dataSource.drive(onNext: { [unowned self] dataSource in
            self.datasource.apply(dataSource, animatingDifferences: false)
            }).disposed(by: disposeBag)
        
        refreshRelay.accept(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding

        return CGSize(width: collectionViewSize / 2, height: collectionViewSize / 2)
    }
}

extension MainViewController {

    final class PhotoCell: UICollectionViewCell {
        
        private lazy var label: UILabel = {
            let label = UILabel()
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 2
            return label
        }()
        
        private lazy var imageView: UIImageView = {
            let imageView = UIImageView()
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            
            return imageView
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            contentView.addSubview(imageView)
            contentView.addSubview(label)
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
                
                label.topAnchor.constraint(equalTo: imageView.bottomAnchor),
                label.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
                label.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func bindTo(data: MarsPhoto.PhotoData) {
            
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 55, weight: .black)
            let placeholder = UIImage(systemName: "house", withConfiguration: imageConfig)
            imageView.imageFromServerURL(data.img_src, placeHolder: placeholder)
            
            label.text = data.rover.name
        }
    }
}
