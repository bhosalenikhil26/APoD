//
//  AopdListViewModelTests.swift
//  AstroPicDailyTests
//
//  Created by Nikhil Bhosale on 2024-05-12.
//

import XCTest
@testable import AstroPicDaily

final class AstroPicListViewModelTests: XCTestCase {
    private var astroPicListViewModel: AstroPicListViewModel!
    private var mockPictureLoaderService: MockPictureLoaderService!

    override func setUpWithError() throws {
        mockPictureLoaderService = MockPictureLoaderService()
        astroPicListViewModel = AstroPicListViewModel(pictureLoaderService: mockPictureLoaderService)
    }

    override func tearDownWithError() throws {
        mockPictureLoaderService = nil
        astroPicListViewModel = nil
    }

    func testLoadPictures_whenLoadPicturesAPISucceeds_shouldUpdateStateToLoadedAndUpdateAstronomyPicsArray() async {
        mockPictureLoaderService.loadPicturesShouldFail = false
        mockPictureLoaderService.astroPicturesArray = [astroPic]
        guard case LoadingState.initial = astroPicListViewModel.loadingState else {
            return XCTFail()
        }
        await astroPicListViewModel.viewAppeared()
        guard case LoadingState.loaded(let astronomyPics) = astroPicListViewModel.loadingState else {
            return XCTFail()
        }
        XCTAssertTrue(astronomyPics.count == 1)
        XCTAssertTrue(astronomyPics[0].title == "title")
        XCTAssertFalse(astroPicListViewModel.showAlert)
    }

    func testLoadPictures_whenLoadPicturesAPIFails_shouldUpdateStateBackToInitialAndShowAlert() async {
        mockPictureLoaderService.loadPicturesShouldFail = true
        guard case LoadingState.initial = astroPicListViewModel.loadingState else {
            return XCTFail()
        }
        await astroPicListViewModel.viewAppeared()
        guard case LoadingState.initial = astroPicListViewModel.loadingState else {
            return XCTFail()
        }
        XCTAssertTrue(astroPicListViewModel.showAlert)
    }

    func testLoadPictures_whenLoadPicturesAPISucceedsButArrayIsEmpty_shouldUpdateStateBackToInitialAndShowAlert() async {
        mockPictureLoaderService.loadPicturesShouldFail = false
        mockPictureLoaderService.astroPicturesArray = []
        guard case LoadingState.initial = astroPicListViewModel.loadingState else {
            return XCTFail()
        }
        await astroPicListViewModel.viewAppeared()
        guard case LoadingState.initial = astroPicListViewModel.loadingState else {
            return XCTFail()
        }
        XCTAssertTrue(astroPicListViewModel.showAlert)
    }


    private var astroPic: AstroPic {
        AstroPic(
            copyright: nil,
            date: "date",
            explanation: "explanation",
            hdurl: "hdurl",
            title: "title",
            url: "url",
            mediaType: "image")
    }
}

private final class MockPictureLoaderService: PictureLoaderServiceProtocol & ImageDownloaderServiceProtocol {
    var loadPicturesShouldFail: Bool = false
    var astroPicturesArray = [AstroPic]()

    func loadLastAstroPictures(numberOfDays: Int) async throws -> [AstroPicDaily.AstroPic] {
        guard !loadPicturesShouldFail else { throw APIError.couldNotParseToSpecifiedModel }
        return astroPicturesArray
    }
    
    func getImage(with url: String) async -> UIImage? {
        nil
    }
}
