//
//  NetworkError.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import Foundation

enum NetworkError:LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case httpStatus(Int)
    case noData
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid response"
        case .httpStatus(let code): return "The request failed with status code: \(code)"
        case .noData: return "No data returned from the server"
        case .decodingError: return "Failed to decode data"
        }
    }
}
