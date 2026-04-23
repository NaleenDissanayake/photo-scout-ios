//
//  APIClient.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import Foundation
import RxSwift

final class APIClient: APIClientProtocol {
    private let requestBuilder: RequestBuilder
    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        requestBuilder: RequestBuilder,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.requestBuilder = requestBuilder
        self.session = session
        self.decoder = decoder
    }

    func request<T: Decodable>(_ endpoint: Endpoint) -> Single<T> {
        Single.create { [requestBuilder, session, decoder] observer in
            do {
                let request = try requestBuilder.makeRequest(for: endpoint)
                let task = session.dataTask(with: request) { data, response, error in
                    if let error {
                        observer(.failure(NetworkError.underlying(error.localizedDescription)))
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse else {
                        observer(.failure(NetworkError.invalidResponse))
                        return
                    }

                    guard (200...299).contains(httpResponse.statusCode) else {
                        observer(.failure(NetworkError.httpStatus(httpResponse.statusCode)))
                        return
                    }

                    guard let data, !data.isEmpty else {
                        observer(.failure(NetworkError.noData))
                        return
                    }

                    do {
                        let decoded = try decoder.decode(T.self, from: data)
                        observer(.success(decoded))
                    } catch {
                        observer(.failure(NetworkError.decodingError))
                    }
                }
                task.resume()

                return Disposables.create {
                    task.cancel()
                }
            } catch {
                observer(.failure(error))
                return Disposables.create()
            }
        }
    }
}
