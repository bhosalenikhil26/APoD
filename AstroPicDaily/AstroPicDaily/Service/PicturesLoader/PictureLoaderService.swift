//
//  PictureLoaderService.swift
//  AstroPicDaily
//
//  Created by Nikhil Bhosale on 2024-05-11.
//

import UIKit

protocol PictureLoaderServiceProtocol {
    func loadLastAstroPictures(numberOfDays: Int) async throws -> [AstroPic]
}

protocol ImageDownloaderServiceProtocol {
    func getImage(with url: String) async -> UIImage?
}

final class PictureLoaderService {
    private let apiPictureLoaderService: APIPictureLoaderServiceProtocol
    private let imageCache: ImageCacheProtocol

    init(apiPictureLoaderService: APIPictureLoaderServiceProtocol, imageCache: ImageCacheProtocol = ImageCache.shared) {
        self.apiPictureLoaderService = apiPictureLoaderService
        self.imageCache = imageCache
    }
}

extension PictureLoaderService: PictureLoaderServiceProtocol, ImageDownloaderServiceProtocol {
    func loadLastAstroPictures(numberOfDays: Int) async throws -> [AstroPic] {
        return try await apiPictureLoaderService.loadPictures(with: getLoadPicturesRequestInput(numberOfDays: numberOfDays))
    }

    func getImage(with url: String) async -> UIImage? {
        if let cachedImage = imageCache.get(forKey: url) {
            return cachedImage
        }
        guard let imageData = try? await apiPictureLoaderService.fetchImage(for: url),
              let uiImage = UIImage(data: imageData) else { return nil }
        imageCache.set(uiImage, forKey: url)
        return uiImage
    }
}

private extension PictureLoaderService {
    func getLoadPicturesRequestInput(numberOfDays: Int) -> APIPictureLoaderService.LoadPicturesRequest {
        var startDateString: String
        var endDateString: String?
        
        let today = Date()
        if let startDate = today.getPastDateBy(noOfDays: numberOfDays) {
            startDateString = startDate.yyyyMMdd
            endDateString = today.yyyyMMdd
        } else {
            startDateString = today.yyyyMMdd
        }

        return APIPictureLoaderService.LoadPicturesRequest(
            apiKey: "DEMO_KEY",
            startDate: startDateString,
            endDate: endDateString
        )
    }
}
