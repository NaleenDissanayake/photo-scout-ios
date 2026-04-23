//
//  Photo.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import Foundation

struct Photo: Equatable {
    let id: Int
    let photographerName: String
    let thumbnailURL: URL?
    let largeImageURL: URL?
    let width: Int
    let height: Int
}
