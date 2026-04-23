//
//  SearchMessageProvider.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import Foundation

enum SearchMessageProvider {
    static func messageForEmptyQuery() -> String {
        SearchStrings.enterKeywordMessage
    }

    static func message(for photos: [Photo]) -> String? {
        photos.isEmpty ? SearchStrings.noResultsMessage : nil
    }

    static func messageForError() -> String {
        SearchStrings.genericErrorMessage
    }
}
