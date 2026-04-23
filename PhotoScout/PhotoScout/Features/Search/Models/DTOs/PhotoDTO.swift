//
//  PhotoDTO.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import Foundation

struct PhotoDTO: Decodable {
    let id: Int
    let width: Int
    let height: Int
    let photographer: String
    let src: PhotoSourceDTO

    func toDomain() -> Photo {
        Photo(
            id: id,
            photographerName: photographer,
            thumbnailURL: URL(string: src.medium),
            largeImageURL: URL(string: src.large2x),
            width: width,
            height: height
        )
    }
}
