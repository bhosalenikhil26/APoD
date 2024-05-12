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
    }

    override func tearDownWithError() throws {
        mockPictureLoaderService = nil
        pictureDetailsViewModel = nil
    }

    func testGetImage_whenGetImageIsSuccessful_shouldSetFetchedImageToStoredproperty() async {
        pictureDetailsViewModel = PictureDetailsViewModel(astroPic: getAstroPic(), pictureLoaderService: mockPictureLoaderService)
        mockPictureLoaderService.shouldGetImageFail = false
        XCTAssertNotNil(pictureDetailsViewModel.image)
        await pictureDetailsViewModel.viewAppeared()
        XCTAssertEqual(UIImage(named: "close"), pictureDetailsViewModel.image)
    }

    func testGetImage_whenGetImageFails_shouldNotAssignNilToStoredProperty() async {
        pictureDetailsViewModel = PictureDetailsViewModel(astroPic: getAstroPic(), pictureLoaderService: mockPictureLoaderService)
        mockPictureLoaderService.shouldGetImageFail = true
        XCTAssertNotNil(pictureDetailsViewModel.image)
        await pictureDetailsViewModel.viewAppeared()
        XCTAssertEqual(UIImage(named: "image-placeholder"), pictureDetailsViewModel.image)
    }

    func testGetImage_whenMediaTypeIsNotImage_shouldReturnWithoutCallingMethodFromService() async {
        pictureDetailsViewModel = PictureDetailsViewModel(astroPic: getAstroPic(with: "video"), pictureLoaderService: mockPictureLoaderService)
        mockPictureLoaderService.shouldGetImageFail = false
        XCTAssertNotNil(pictureDetailsViewModel.image)
        await pictureDetailsViewModel.viewAppeared()
        XCTAssertEqual(UIImage(named: "image-placeholder"), pictureDetailsViewModel.image)
        XCTAssertTrue(mockPictureLoaderService.getImageCallCounter == 0)
    }

    func getAstroPic(with mediaType: String = "image") -> AstroPic {
        AstroPic(
            copyright: nil,
            date: "date",
            explanation: "explanation",
            hdurl: "hdurl",
            title: "title",
            url: "url",
            mediaType: mediaType)
    }
}

private final class MockPictureLoaderService: ImageDownloaderServiceProtocol {
    var shouldGetImageFail: Bool = false
    var getImageCallCounter: Int = 0

    func getImage(with url: String) async -> UIImage? {
        getImageCallCounter += 1
        guard shouldGetImageFail else {
            return UIImage(named: "close")
        }
        return nil
    }
}
