//
//  PictureDetailsViewModelTests.swift
//  AstroPicDailyTests
//
//  Created by Nikhil Bhosale on 2024-05-12.
//

import XCTest
@testable import AstroPicDaily

final class PictureDetailsViewModelTests: XCTestCase {
    private var pictureDetailsViewModel: PictureDetailsViewModel!
    private var mockPictureLoaderService: MockPictureLoaderService!

    override func setUpWithError() throws {
        mockPictureLoaderService = MockPictureLoaderService()
        pictureDetailsViewModel = PictureDetailsViewModel(astroPic: astroPic, pictureLoaderService: mockPictureLoaderService)
    }

    override func tearDownWithError() throws {
        mockPictureLoaderService = nil
        pictureDetailsViewModel = nil
    }

    func testGetImage_whenGetImageIsSuccessful_shouldSetFetchedImageToStoredproperty() async {
        mockPictureLoaderService.shouldGetImageFail = false
        XCTAssertNotNil(pictureDetailsViewModel.image)
        await pictureDetailsViewModel.viewAppeared()
        XCTAssertEqual(UIImage(named: "close"), pictureDetailsViewModel.image)
    }

    func testGetImage_whenGetImageFails_shouldNotAssignNilToStoredProperty() async {
        mockPictureLoaderService.shouldGetImageFail = true
        XCTAssertNotNil(pictureDetailsViewModel.image)
        await pictureDetailsViewModel.viewAppeared()
        XCTAssertEqual(UIImage(named: "image-placeholder"), pictureDetailsViewModel.image)
    }

    private var astroPic: AstroPic {
        AstroPic(
            copyright: nil,
            date: "date",
            explanation: "explanation",
            hdurl: "hdurl",
            title: "title",
            url: "url")
    }
}

private final class MockPictureLoaderService: PictureLoaderServiceProtocol {
    var shouldGetImageFail: Bool = false

    func loadLastAstroPictures(numberOfDays: Int) async throws -> [AstroPicDaily.AstroPic] { [] }

    func getImage(with url: String) async -> UIImage? {
        guard shouldGetImageFail else {
            return UIImage(named: "close")
        }
        return nil
    }
}
