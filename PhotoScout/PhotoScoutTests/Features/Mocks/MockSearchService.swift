//
//  MockSearchService.swift
//  PhotoScoutTests
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import Foundation
import RxSwift

@testable import PhotoScout

final class MockSearchService: SearchServiceProtocol {
    var result: Single<[Photo]> = .just([])
    private(set) var receivedQuery: String?
    private(set) var receivedPage: Int?
    private(set) var receivedPerPage: Int?

    func searchPhotos(query: String, page: Int, perPage: Int) -> Single<[Photo]> {
        receivedQuery = query
        receivedPage = page
        receivedPerPage = perPage
        return result
    }
}
