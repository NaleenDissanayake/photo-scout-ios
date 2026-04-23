//
//  SearchViewModel.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {
    struct Input {
        let searchText: Observable<String>
        let itemSelected: Observable<Photo>
    }

    struct Output {
        let photos: Driver<[Photo]>
        let isLoading: Driver<Bool>
        let message: Driver<String?>
        let selectedPhoto: Signal<Photo>
    }

    private let searchService: SearchServiceProtocol
    private let scheduler: SchedulerType
    private let debounceDueTime: RxTimeInterval
    private let page: Int
    private let perPage: Int

    init(
        searchService: SearchServiceProtocol,
        scheduler: SchedulerType = MainScheduler.instance,
        debounceDueTime: RxTimeInterval = .milliseconds(400),
        page: Int = 1,
        perPage: Int = 20 // We initially set 20 items per page
    ) {
        self.searchService = searchService
        self.scheduler = scheduler
        self.debounceDueTime = debounceDueTime
        self.page = page
        self.perPage = perPage
    }

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let messageRelay = BehaviorRelay<String?>(value: SearchStrings.enterKeywordMessage)

        let query = SearchQueryBuilder.build(
            from: input.searchText,
            debounceDueTime: debounceDueTime,
            scheduler: scheduler
        )

        let photos = query
            .flatMapLatest { [weak self] query -> Observable<[Photo]> in
                guard let self else { return .just([]) }

                guard !query.isEmpty else {
                    messageRelay.accept(SearchStrings.enterKeywordMessage)
                    return .just([])
                }

                return self.searchService
                    .searchPhotos(query: query, page: self.page, perPage: self.perPage)
                    .asObservable()
                    .trackActivity(activityIndicator)
                    .do(
                        onNext: { photos in
                            messageRelay.accept(
                                photos.isEmpty ? SearchStrings.noResultsMessage : nil
                            )
                        },
                        onError: { _ in
                            messageRelay.accept(SearchStrings.genericErrorMessage)
                        }
                    )
                    .catchAndReturn([])
            }
            .startWith([])
            .share(replay: 1, scope: .whileConnected)

        return Output(
            photos: photos.asDriver(onErrorJustReturn: []),
            isLoading: activityIndicator.asSharedSequence(),
            message: messageRelay.asDriver(),
            selectedPhoto: input.itemSelected.asSignal(onErrorSignalWith: .empty())
        )
    }
}
