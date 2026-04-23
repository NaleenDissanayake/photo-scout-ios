//
//  RequestBuilder.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import Foundation

struct RequestBuilder {
    private let configuration: AppConfig

    init(configuration: AppConfig) {
        self.configuration = configuration
    }

    func makeRequest(for endpoint: Endpoint) throws -> URLRequest {
        guard var components = URLComponents(
            url: configuration.apiBaseURL.appendingPathComponent(endpoint.path),
            resolvingAgainstBaseURL: false
        ) else {
            throw NetworkError.invalidURL
        }

        components.queryItems = endpoint.queryItems

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue(configuration.pexelsAPIKey, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        endpoint.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}
