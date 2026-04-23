//
//  SearchServiceProtocol.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import RxSwift

protocol SearchServiceProtocol {
    func searchPhotos(query: String, page: Int, perPage: Int) -> Single<[Photo]>
}
