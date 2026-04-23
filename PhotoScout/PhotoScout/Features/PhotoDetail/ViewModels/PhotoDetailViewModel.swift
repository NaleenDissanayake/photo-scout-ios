//
//  PhotoDetailViewModel.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import Foundation

struct PhotoDetailViewModel {
    let photo: Photo

    var titleText: String {
        photo.photographerName
    }

    var imageURL: URL? {
        photo.largeImageURL ?? photo.thumbnailURL
    }
}
