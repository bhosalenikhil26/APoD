//
//  APIService.swift
//  AstroPicDaily
//
//  Created by Nikhil Bhosale on 2024-05-11.
//

import Foundation

enum APIError: Error {
    case invalidUrl
    case couldNotParseToSpecifiedModel
    case failedToParseDataIntoImage
}

protocol APIRequest {
    var url: URL? { get }
}

extension APIRequest {}

protocol APIServiceProtocol {
    func executeApiRequest(_ request: APIRequest) async throws -> Data
}

extension APIServiceProtocol {
    func executeApiRequest(_ request: APIRequest) async throws -> Data {
        guard let url = request.url else {
            throw APIError.invalidUrl
        }
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        return data
    }
}
