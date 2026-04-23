//
//  ViewController.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = SearchPhotoCellPreviewVC()
        navigationController?.pushViewController(vc, animated: true)
        //testSearchService()
    }

    private func testSearchService() {
        let requestBuilder = RequestBuilder(configuration: AppConfig(bundle: .main))

        let apiClient = APIClient(requestBuilder: requestBuilder)
        let searchService = PexelsSearchService(apiClient: apiClient)
        
        searchService
            .searchPhotos(query: "Nature", page: 1, perPage: 10)
            .subscribe(
                onSuccess: { photos in
                    print("Photo count: \(photos.count)")
                    
                    for photo in photos {
                        print("""
                            id: \(photo.id)
                            photographer: \(photo.photographerName)
                            size: \(photo.width)x\(photo.height)
                            """)
                    }
                },
                onFailure: { error in
                    print("Error : \(error)")
                }
            )
            .disposed(by: disposeBag)
    }

}

