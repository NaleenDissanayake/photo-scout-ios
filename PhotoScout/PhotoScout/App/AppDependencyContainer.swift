//
//  AppDependencyContainer.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import Foundation
import UIKit

final class AppDependencyContainer {
    private lazy var configuration = AppConfig(bundle: .main)
    private lazy var requestBuilder = RequestBuilder(configuration: configuration)
    private lazy var apiClient: APIClientProtocol = APIClient(requestBuilder: requestBuilder)
    private lazy var searchService: SearchServiceProtocol = PexelsSearchService(apiClient: apiClient)
    private lazy var imageLoader: ImageLoading = ImageLoader()

    func configure(searchViewController: SearchViewController) {
        let viewModel = SearchViewModel(searchService: searchService)
        searchViewController.inject(
            viewModel: viewModel,
            imageLoader: imageLoader,
            dependencyContainer: self
        )
    }
}
