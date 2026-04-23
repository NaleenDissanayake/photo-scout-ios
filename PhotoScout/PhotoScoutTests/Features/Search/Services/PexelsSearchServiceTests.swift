//
//  PexelsSearchServiceTests.swift
//  PhotoScoutTests
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import Testing
import Foundation
import RxBlocking
import RxSwift

@testable import PhotoScout

@Suite("PexelsSearchService")
struct PexelsSearchServiceTests {
    @Test("Maps DTO response into Photo models")
    func mapsResponseToPhotos() throws {
        let apiClient = MockAPIClient()
        let service = PexelsSearchService(apiClient: apiClient)
        
        let dto = PhotoSearchResponseDTO(
            page: 1,
            perPage: 20,
            photos: [
                PhotoDTO(
                    id: 10,
                    width: 1200,
                    height: 800,
                    photographer: "Naleen",
                    src: PhotoSourceDTO(
                        original: "https://pexels.com/original.jpg",
                        large2x: "https://pexels.com/large2x.jpg",
                        large: "https://pexels.com/large.jpg",
                        medium: "https://pexels.com/medium.jpg",
                        small: "https://pexels.com/small.jpg",
                        portrait: "https://pexels.com/portrait.jpg",
                        landscape: "https://pexels.com/landscape.jpg",
                        tiny: "https://pexels.com/tiny.jpg"
                    )
                )
            ],
            totalResults: 1,
            nextPage: nil
        )
        
        apiClient.responseData = dto
        
        let photos = try service
            .searchPhotos(query: "nature", page: 1, perPage: 20)
            .toBlocking()
            .single()
        
        #expect(photos.count == 1)
        #expect(photos[0].id == 10)
        #expect(photos[0].photographerName == "Naleen")
        #expect(photos[0].thumbnailURL?.absoluteString == "https://pexels.com/medium.jpg")
        #expect(photos[0].largeImageURL?.absoluteString == "https://pexels.com/large2x.jpg")
    }
}
