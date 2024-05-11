//
//  Codable+Extensions.swift
//  AstroPicDaily
//
//  Created by Nikhil Bhosale on 2024-05-11.
//

import Foundation

extension Encodable {
    func asDictionary(keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy? = nil) throws -> [String: Any]? {
        let encoder = JSONEncoder()
        if let keyEncodingStrategy = keyEncodingStrategy {
            encoder.keyEncodingStrategy = keyEncodingStrategy
        }
        guard let encodedData = try? encoder.encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: encodedData, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
