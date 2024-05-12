//
//  APIPictureLoaderService.swift
//  AstroPicDaily
//
//  Created by Nikhil Bhosale on 2024-05-11.
//

import Foundation

typealias AstroPic = APIPictureLoaderService.LoadPicturesResponse

protocol APIPictureLoaderServiceProtocol: APIServiceProtocol {
    func loadPictures(with details: APIPictureLoaderService.LoadPicturesRequest) async throws -> [AstroPic]
    func fetchImage(for url: String) async throws -> Data
}

final class APIPictureLoaderService {}

extension APIPictureLoaderService: APIPictureLoaderServiceProtocol {
    func loadPictures(with details: LoadPicturesRequest) async throws -> [AstroPic] {
        let request = APIPictureLoaderRequest.fetchPictures(request: details)
        let data = try await executeApiRequest(request)
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([AstroPic].self, from: data)
        } catch {
            throw APIError.couldNotParseToSpecifiedModel
        }
    }

    func fetchImage(for url: String) async throws -> Data {
        let request = APIPictureLoaderRequest.fetchImage(url: url)
        return try await executeApiRequest(request)
    }
}

extension APIPictureLoaderService {
    struct LoadPicturesRequest: Encodable {
        let apiKey: String
        let startDate: String
        let endDate: String?
    }

    struct LoadPicturesResponse: Decodable, Hashable {
        let copyright: String?
        let date: String
        let explanation: String
        let hdurl: String?
        let title: String
        let url: String
        let mediaType: String
    }
}

extension AstroPic {
    var isImageTypeMedia: Bool {
        mediaType == "image"
    }
}
