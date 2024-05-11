//
//  PictureLoaderService.swift
//  AstroPicDaily
//
//  Created by Nikhil Bhosale on 2024-05-11.
//

import SwiftUI

protocol PictureLoaderServiceProtocol {
    func loadPictures() async throws -> [AstroPics]
}

final class PictureLoaderService {
    private let apiPictureLoaderService: APIPictureLoaderServiceProtocol

    init(apiPictureLoaderService: APIPictureLoaderServiceProtocol) {
        self.apiPictureLoaderService = apiPictureLoaderService
    }
}

extension PictureLoaderService: PictureLoaderServiceProtocol {
    func loadPictures() async throws -> [AstroPics] {
        []
    }
}

