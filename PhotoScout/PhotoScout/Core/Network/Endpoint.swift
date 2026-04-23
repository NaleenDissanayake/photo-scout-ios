//
//  Endpoint.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var headers: [String: String] { get }
}
