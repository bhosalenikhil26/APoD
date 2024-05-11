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

    func testGetImage_whenImageIsDownloadedButDataIsCorrupt_shouldReturnNil() async {
        mockAPIService.imageData = Data()
        mockAPIService.downloadFileCallCounter = 0
        let uiImage = await pictureLoaderService.getImage(with: "testUrl")
        XCTAssertTrue(mockAPIService.downloadFileCallCounter == 1)
        XCTAssertNil(uiImage)
    }

    func testGetImage_whenImageIsDownloadedSuccessful_shouldBeCacheedInService() async {
        mockAPIService.imageData = UIImage(named: "close")!.pngData()!
        mockAPIService.downloadFileCallCounter = 0
        _ = await pictureLoaderService.getImage(with: "testUrl")
        XCTAssertTrue(mockAPIService.downloadFileCallCounter == 1)
        _ = await pictureLoaderService.getImage(with: "testUrl")
        XCTAssertTrue(mockAPIService.downloadFileCallCounter == 1)
    }
}

private final class MockAPIPictureLoaderService: APIPictureLoaderServiceProtocol {
    var downloadFileCallCounter: Int = 0
    var imageData: Data!

    func fetchImage(for url: String) async throws -> Data {
        downloadFileCallCounter = +1
        return imageData
    }
    
    var loadPicturesRequest: APIPictureLoaderService.LoadPicturesRequest?
    func loadPictures(with details: APIPictureLoaderService.LoadPicturesRequest) async throws -> [AstroPics] {
        loadPicturesRequest = details
        return []
    }
}
