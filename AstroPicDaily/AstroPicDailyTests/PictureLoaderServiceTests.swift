//
//  PictureLoaderServiceTests.swift
//  AstroPicDailyTests
//
//  Created by Nikhil Bhosale on 2024-05-11.
//

import XCTest
@testable import AstroPicDaily

final class PictureLoaderServiceTests: XCTestCase {
    private var pictureLoaderService: PictureLoaderServiceProtocol!
    private var mockAPIService: MockAPIPictureLoaderService!

    override func setUpWithError() throws {
        mockAPIService = MockAPIPictureLoaderService()
        pictureLoaderService = PictureLoaderService(apiPictureLoaderService: mockAPIService)
    }

    override func tearDownWithError() throws {
        mockAPIService = nil
        pictureLoaderService = nil
    }

    func testLoadLastAstroPictures_whenBothStartAndEndDateArePresent_shouldCreateLoadPicturesRequestWithEndDate() async throws {
        _ = try await pictureLoaderService.loadLastAstroPictures(for: 7)
        XCTAssertNotNil(mockAPIService.loadPicturesRequest)
        XCTAssertNotNil(mockAPIService.loadPicturesRequest?.endDate)
    }
}

private final class MockAPIPictureLoaderService: APIPictureLoaderServiceProtocol {
    var loadPicturesRequest: APIPictureLoaderService.LoadPicturesRequest?
    func loadPictures(with details: APIPictureLoaderService.LoadPicturesRequest) async throws -> [AstroPics] {
        loadPicturesRequest = details
        return []
    }
}
