//
//  APIPictureLoaderRequest.swift
//  AstroPicDaily
//
//  Created by Nikhil Bhosale on 2024-05-11.
//

import Foundation

public enum HTTPMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}

enum APIPictureLoaderRequest: APIRequest {
    case fetchPictures(request: APIPictureLoaderService.LoadPicturesRequest)

    var baseURLPath: String {
        switch self {
        case .fetchPictures: return ServerEnvironment.serverUrl
        }
    }

    var path: String {
        switch self {
        case .fetchPictures: return "planetary/apod"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchPictures: return .get
        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .fetchPictures(let request): return try? request.asDictionary(keyEncodingStrategy: .convertToSnakeCase) as? [String: String]
        }
    }

    var url: URL? {
        guard var urlComponents = URLComponents(string: baseURLPath + path) else { return nil }
        if urlComponents.queryItems == nil || urlComponents.queryItems?.isEmpty == true {
            urlComponents.queryItems = queryParameters?.map { URLQueryItem(name: $0, value: $1) }
        } else if let queryParams = queryParameters, var queryItems = urlComponents.queryItems {
            queryItems.append(contentsOf: queryParams.map { URLQueryItem(name: $0, value: $1) })
            urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else { return nil }
        return url
    }
}

