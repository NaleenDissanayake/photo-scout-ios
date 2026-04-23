//
//  PexelsSearchService.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import RxSwift

final class PexelsSearchService: SearchServiceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func searchPhotos(query: String, page: Int, perPage: Int) -> Single<[Photo]> {
        let endpoint = SearchPhotosEndpoint(query: query, page: page, perPage: perPage)

        return apiClient
            .request(endpoint)
            .map { (response: PhotoSearchResponseDTO) in
                response.photos.map { $0.toDomain() }
            }
    }
}
