//
//  SearchMessageProviderTests.swift
//  PhotoScoutTests
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import Testing

@testable import PhotoScout

@Suite("SearchMessageProvider")
struct SearchMessageProviderTests {
    @Test("Empty query message")
    func emptyQueryMessage() {
        #expect(
            SearchMessageProvider.messageForEmptyQuery() == SearchStrings.enterKeywordMessage
        )
    }
    
    @Test("Returns no-results message for empty photos")
    func noResultsMessage() {
        let result = SearchMessageProvider.message(for: [])
        #expect(result == SearchStrings.noResultsMessage)
    }
    
    @Test("Returns nil when photos exist")
    func successMessage() {
        let photos = [
            Photo(
                id: 1,
                photographerName: "Naleen",
                thumbnailURL: nil,
                largeImageURL: nil,
                width: 100,
                height: 100
            )
        ]
        
        let result = SearchMessageProvider.message(for: photos)
        #expect(result == nil)
    }
    
    @Test("Generic error message")
    func errorMessage() {
        #expect(
            SearchMessageProvider.messageForError() == SearchStrings.genericErrorMessage
        )
    }
}
