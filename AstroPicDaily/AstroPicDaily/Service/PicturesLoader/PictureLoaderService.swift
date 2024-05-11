//
//  PictureLoaderService.swift
//  AstroPicDaily
//
//  Created by Nikhil Bhosale on 2024-05-11.
//

import SwiftUI

protocol PictureLoaderServiceProtocol {
    func loadLastAstroPictures(for numberOfDays: Int) async throws -> [AstroPics]
}

final class PictureLoaderService {
    private let apiPictureLoaderService: APIPictureLoaderServiceProtocol

    init(apiPictureLoaderService: APIPictureLoaderServiceProtocol) {
        self.apiPictureLoaderService = apiPictureLoaderService
    }
}

extension PictureLoaderService: PictureLoaderServiceProtocol {
    func loadLastAstroPictures(for numberOfDays: Int) async throws -> [AstroPics] {
        return try await apiPictureLoaderService.loadPictures(with: getLoadPicturesRequestInput(numberOfDays: numberOfDays))
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
