//
//  MockAPIClient.swift
//  PhotoScoutTests
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import Foundation
import RxSwift

@testable import PhotoScout

final class MockAPIClient: APIClientProtocol {
    var responseData: Any?
    var error: Error?

    func request<T>(_ endpoint: Endpoint) -> Single<T> where T: Decodable {
        if let error {
            return .error(error)
        }

        guard let response = responseData as? T else {
            return .error(NetworkError.decodingError)
        }

        return .just(response)
    }
}
