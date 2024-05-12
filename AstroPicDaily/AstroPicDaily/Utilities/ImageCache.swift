//
//  ImageCache.swift
//  AstroPicDaily
//
//  Created by Nikhil Bhosale on 2024-05-11.
//

import Foundation
import UIKit
import Network

protocol ImageCacheProtocol {
    func set(_ image: UIImage, forKey key: String)
    func get(forKey key: String) -> UIImage?
}

final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()

    private init() {}
}

extension ImageCache: ImageCacheProtocol {
    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}
