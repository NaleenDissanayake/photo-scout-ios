//
//  ImageLoader.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import RxSwift
import UIKit

final class ImageLoader: ImageLoading {
    private let session: URLSession
    private let cache: ImageMemoryCache

    init(session: URLSession = .shared, cache: ImageMemoryCache = .shared) {
        self.session = session
        self.cache = cache
    }

    func loadImage(from url: URL?) -> Single<UIImage?> {
        guard let url else {
            return .just(nil)
        }

        if let cached = cache.image(for: url) {
            return .just(cached)
        }

        return Single.create { [session, cache] observer in
            let task = session.dataTask(with: url) { data, _, error in
                if let error {
                    observer(.failure(error))
                    return
                }

                guard let data, let image = UIImage(data: data) else {
                    observer(.success(nil))
                    return
                }

                cache.insert(image, for: url)
                observer(.success(image))
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
