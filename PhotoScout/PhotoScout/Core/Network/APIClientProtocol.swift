//
//  APIClientProtocol.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import RxSwift

protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) -> Single<T>
}
