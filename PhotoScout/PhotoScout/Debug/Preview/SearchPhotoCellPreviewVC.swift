//
//  SearchPhotoCellPreviewVC.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import UIKit

class SearchPhotoCellPreviewVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        let cell = SearchPhotoCell(frame: CGRect(x: 20, y: 120, width: 180, height: 220))
        view.addSubview(cell)

        let photo = Photo(
            id: 1,
            photographerName: "Naleen Dissanayake",
            thumbnailURL: nil,
            largeImageURL: nil,
            width: 1200,
            height: 800
        )

        cell.configure(with: photo, imageLoader: MockImageLoader())
    }

}
