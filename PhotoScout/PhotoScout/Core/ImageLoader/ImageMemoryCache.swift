//
//  ImageMemoryCache.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import UIKit

final class ImageMemoryCache {
    static let shared = ImageMemoryCache()

    private let cache = NSCache<NSURL, UIImage>()

    private init() {
        cache.countLimit = 300
    }

    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    func insert(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}
