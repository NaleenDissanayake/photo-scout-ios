//
//  SearchViewModelTests.swift
//  PhotoScoutTests
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import Testing
import Foundation
import RxSwift
import RxCocoa

@testable import PhotoScout

@Suite("SearchViewModel")
struct SearchViewModelTests {
    @Test("Empty query shows initial message and returns empty photos")
    @MainActor
    func emptyQuery() async throws {
        let service = MockSearchService()
        let viewModel = SearchViewModel(
            searchService: service,
            scheduler: MainScheduler.instance,
            debounceDueTime: .milliseconds(0),
            page: 1,
            perPage: 20
        )
        
        let searchText = PublishSubject<String>()
        let itemSelected = PublishSubject<Photo>()
        
        let input = SearchViewModel.Input(
            searchText: searchText.asObservable(),
            itemSelected: itemSelected.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        var messages: [String?] = []
        var photoSnapshots: [[Photo]] = []
        
        let disposeBag = DisposeBag()
        
        output.message
            .drive(onNext: { messages.append($0) })
            .disposed(by: disposeBag)
        
        output.photos
            .drive(onNext: { photoSnapshots.append($0) })
            .disposed(by: disposeBag)
        
        searchText.onNext("   ")
        
        try await Task.sleep(for: .milliseconds(50))
        
        #expect(messages.contains(SearchStrings.enterKeywordMessage))
        #expect(photoSnapshots.last == [])
        #expect(service.receivedQuery == nil)
    }
    
    @Test("Successful search returns photos and clears message")
    @MainActor
    func successfulSearch() async throws {
        let expectedPhotos = [
            Photo(
                id: 1,
                photographerName: "Naleen",
                thumbnailURL: nil,
                largeImageURL: nil,
                width: 300,
                height: 200
            )
        ]
        
        let service = MockSearchService()
        service.result = .just(expectedPhotos)
        
        let viewModel = SearchViewModel(
            searchService: service,
            scheduler: MainScheduler.instance,
            debounceDueTime: .milliseconds(0),
            page: 1,
            perPage: 20
        )
        
        let searchText = PublishSubject<String>()
        let itemSelected = PublishSubject<Photo>()
        
        let input = SearchViewModel.Input(
            searchText: searchText.asObservable(),
            itemSelected: itemSelected.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        var messages: [String?] = []
        var photoSnapshots: [[Photo]] = []
        
        let disposeBag = DisposeBag()
        
        output.message
            .drive(onNext: { messages.append($0) })
            .disposed(by: disposeBag)
        
        output.photos
            .drive(onNext: { photoSnapshots.append($0) })
            .disposed(by: disposeBag)
        
        searchText.onNext("nature")
        
        try await Task.sleep(for: .milliseconds(50))
        
        #expect(service.receivedQuery == "nature")
        #expect(photoSnapshots.last == expectedPhotos)
        #expect(messages.last! == nil)
    }
    
    @Test("Successful search with no results shows no-results message")
    @MainActor
    func noResultsSearch() async throws {
        let service = MockSearchService()
        service.result = .just([])
        
        let scheduler = SerialDispatchQueueScheduler(qos: .default)
        
        let viewModel = SearchViewModel(
            searchService: service,
            scheduler: scheduler,
            debounceDueTime: .milliseconds(0),
            page: 1,
            perPage: 20
        )
        
        let searchText = PublishSubject<String>()
        let itemSelected = PublishSubject<Photo>()
        
        let input = SearchViewModel.Input(
            searchText: searchText.asObservable(),
            itemSelected: itemSelected.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        var latestMessage: String?
        var latestPhotos: [Photo] = []
        let disposeBag = DisposeBag()
        
        output.message
            .drive(onNext: { latestMessage = $0 })
            .disposed(by: disposeBag)
        
        output.photos
            .drive(onNext: { latestPhotos = $0 })
            .disposed(by: disposeBag)
        
        searchText.onNext("nature")
        
        try await Task.sleep(for: .milliseconds(150))
        
        #expect(service.receivedQuery == "nature")
        #expect(latestPhotos.isEmpty)
        #expect(latestMessage == SearchStrings.noResultsMessage)
    }
    
    @Test("Error from service shows generic error message and returns empty photos")
    @MainActor
    func errorSearch() async throws {
        let service = MockSearchService()
        service.result = .error(NetworkError.noData)
        
        let viewModel = SearchViewModel(
            searchService: service,
            scheduler: MainScheduler.instance,
            debounceDueTime: .milliseconds(0),
            page: 1,
            perPage: 20
        )
        
        let searchText = PublishSubject<String>()
        let itemSelected = PublishSubject<Photo>()
        
        let input = SearchViewModel.Input(
            searchText: searchText.asObservable(),
            itemSelected: itemSelected.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        var messages: [String?] = []
        var photoSnapshots: [[Photo]] = []
        
        let disposeBag = DisposeBag()
        
        output.message
            .drive(onNext: { messages.append($0) })
            .disposed(by: disposeBag)
        
        output.photos
            .drive(onNext: { photoSnapshots.append($0) })
            .disposed(by: disposeBag)
        
        searchText.onNext("nature")
        
        try await Task.sleep(for: .milliseconds(50))
        
        #expect(messages.contains(SearchStrings.genericErrorMessage))
        #expect(photoSnapshots.last == [])
    }
}
