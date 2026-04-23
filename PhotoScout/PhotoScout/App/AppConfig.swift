//
//  AppConfig.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import Foundation

struct AppConfig {
    let apiBaseURL: URL
    let pexelsAPIKey: String

    init(bundle: Bundle) {
        guard let baseURLString = bundle.object(forInfoDictionaryKey: "PEXELS_BASE_URL") as? String,
              let apiBaseURL = URL(string: baseURLString) else {
            fatalError("Missing PEXELS_BASE_URL in Info.plist")
        }

        guard let pexelsAPIKey = bundle.object(forInfoDictionaryKey: "PEXELS_API_KEY") as? String,
              !pexelsAPIKey.isEmpty,
              pexelsAPIKey != "$(PEXELS_API_KEY)" else {
            fatalError("Missing PEXELS_API_KEY in Info.plist / xcconfig")
        }

        self.apiBaseURL = apiBaseURL
        self.pexelsAPIKey = pexelsAPIKey
    }
}
