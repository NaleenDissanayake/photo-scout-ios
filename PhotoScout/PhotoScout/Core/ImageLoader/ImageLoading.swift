//
//  ImageLoading.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import RxSwift
import UIKit

protocol ImageLoading {
    func loadImage(from url: URL?) -> Single<UIImage?>
}
