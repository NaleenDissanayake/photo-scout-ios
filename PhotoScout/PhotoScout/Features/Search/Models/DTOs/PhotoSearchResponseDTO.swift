//
//  PhotoSearchResponseDTO.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import Foundation

struct PhotoSearchResponseDTO: Decodable {
    let page: Int
    let perPage: Int
    let photos: [PhotoDTO]
    let totalResults: Int
    let nextPage: String?

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case photos
        case totalResults = "total_results"
        case nextPage = "next_page"
    }
}
