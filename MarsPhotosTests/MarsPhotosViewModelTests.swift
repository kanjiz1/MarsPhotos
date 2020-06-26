//
//  MarsPhotosTests.swift
//  MarsPhotosTests
//
//  Created by Oforkanji Odekpe on 6/25/20.
//  Copyright © 2020 Oforkanji Odekpe. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
@testable import MarsPhotos

class MarsPhotosViewModelTests: XCTestCase {
    
    typealias Item = MainViewController.Item
    typealias Section = MainViewController.Section
    
    var viewModel: ViewModel!
    var disposeBag: DisposeBag!
    var data: MarsPhoto!
    var bundle = Bundle(for: MarsPhotosViewModelTests.self)
    
    override func setUp() {
        super.setUp()
        
        viewModel = ViewModel()
        disposeBag = DisposeBag()
        
        do {
            let path = bundle.path(forResource: "Sample", ofType: "json")
            let loadedData = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
            data = try JSONDecoder().decode(MarsPhoto.self, from: loadedData)
        } catch {
            print(error)
        }
    }
    
    override func tearDown() {
        disposeBag = nil
        super.tearDown()
    }
    
    func testViewModel() {
        let expectation = self.expectation(description: "")
        
        let outputs = viewModel.getData(inputs: ViewModel.Inputs(refresh: .just(true)))
        
        outputs.dataSource.asObservable().take(1).subscribe(onNext: { snapshot in
            if !snapshot.itemIdentifiers.isEmpty {
                expectation.fulfill()
            } else {
                XCTFail("Snapshot empty")
            }
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
