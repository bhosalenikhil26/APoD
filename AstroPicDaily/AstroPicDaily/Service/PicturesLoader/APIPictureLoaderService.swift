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
    func fetchImage(for url: String) async throws -> Data
}

final class APIPictureLoaderService {}

extension APIPictureLoaderService: APIPictureLoaderServiceProtocol {
    func loadPictures(with details: LoadPicturesRequest) async throws -> [AstroPics] {
        let request = APIPictureLoaderRequest.fetchPictures(request: details)
        let data = try await executeApiRequest(request)
        do {
            return try JSONDecoder().decode([AstroPics].self, from: data)
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

    struct LoadPicturesResponse: Decodable {
        let copyright: String?
        let date: String
        let explanation: String
        let hdurl: String?
        let title: String
        let url: String
    }
}
