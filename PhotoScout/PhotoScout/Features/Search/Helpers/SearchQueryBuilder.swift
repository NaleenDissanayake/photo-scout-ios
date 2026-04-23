//
//  SearchQueryBuilder.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import Foundation
import RxSwift

enum SearchQueryBuilder {
    static func build(
        from searchText: Observable<String>,
        debounceDueTime: RxTimeInterval,
        scheduler: SchedulerType
    ) -> Observable<String> {
        searchText
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .debounce(debounceDueTime, scheduler: scheduler)
            .distinctUntilChanged()
            .share(replay: 1, scope: .whileConnected)
    }
}
