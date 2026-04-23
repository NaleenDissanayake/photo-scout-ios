//
//  MockImageLoader.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import UIKit
import RxSwift

final class MockImageLoader: ImageLoading {
    func loadImage(from url: URL?) -> Single<UIImage?> {
        let image = UIImage(systemName: "photo")
        return .just(image)
    }
}
