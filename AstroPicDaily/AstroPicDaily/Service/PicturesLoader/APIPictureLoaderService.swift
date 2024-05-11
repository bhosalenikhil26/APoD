//
//  APIPictureLoaderService.swift
//  AstroPicDaily
//
//  Created by Nikhil Bhosale on 2024-05-11.
//

import Foundation

typealias AstroPics = APIPictureLoaderService.LoadPicturesResponse

protocol APIPictureLoaderServiceProtocol: APIServiceProtocol {
    func loadPictures(with details: APIPictureLoaderService.LoadPicturesRequest) async throws -> [AstroPics]
}

final class APIPictureLoaderService {}

extension APIPictureLoaderService: APIPictureLoaderServiceProtocol {
    func loadPictures(with details: LoadPicturesRequest) async throws -> [AstroPics] {
       []
    }
}

extension APIPictureLoaderService {
    struct LoadPicturesRequest: Encodable {
        let demoKey: String
        let startDate: String
        let endDate: String
    }

    struct LoadPicturesResponse: Decodable {
        let copyright: String?
        let date: String
        let explanation: String
        let hdUrl: String
        let title: String
    }
}
