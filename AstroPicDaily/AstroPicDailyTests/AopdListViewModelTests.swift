//
//  AopdListViewModelTests.swift
//  AstroPicDailyTests
//
//  Created by Nikhil Bhosale on 2024-05-12.
//

import XCTest
@testable import AstroPicDaily

final class AopdListViewModelTests: XCTestCase {
    private var aopdListViewModel: AopdListViewModel!
    private var mockPictureLoaderService: MockPictureLoaderService!

    override func setUpWithError() throws {
        mockPictureLoaderService = MockPictureLoaderService()
        aopdListViewModel = AopdListViewModel(pictureLoaderService: mockPictureLoaderService)
    }

    override func tearDownWithError() throws {
        mockPictureLoaderService = nil
        aopdListViewModel = nil
    }

    func testLoadPictures_whenLoadPicturesAPISucceeds_shouldUpdateStateToLoadedAndUpdateAstronomyPicsArray() async {
        mockPictureLoaderService.loadPicturesShouldFail = false
        mockPictureLoaderService.astroPicturesArray = [astroPic]
        XCTAssertTrue(aopdListViewModel.loadingState == .initial)
        await aopdListViewModel.viewAppeared()
        XCTAssertTrue(aopdListViewModel.astronomyPics.count == 1)
        XCTAssertTrue(aopdListViewModel.astronomyPics[0].title == "title")
        XCTAssertTrue(aopdListViewModel.loadingState == .loaded)
        XCTAssertFalse(aopdListViewModel.showAlert)
    }

    func testLoadPictures_whenLoadPicturesAPIFails_shouldUpdateStateBackToInitialAndShowAlert() async {
        mockPictureLoaderService.loadPicturesShouldFail = true
        XCTAssertTrue(aopdListViewModel.loadingState == .initial)
        await aopdListViewModel.viewAppeared()
        XCTAssertTrue(aopdListViewModel.astronomyPics.count == 0)
        XCTAssertTrue(aopdListViewModel.loadingState == .initial)
        XCTAssertTrue(aopdListViewModel.showAlert)
    }

    func testLoadPictures_whenLoadPicturesAPISucceedsButArrayIsEmpty_shouldUpdateStateBackToInitialAndShowAlert() async {
        mockPictureLoaderService.loadPicturesShouldFail = false
        mockPictureLoaderService.astroPicturesArray = []
        XCTAssertTrue(aopdListViewModel.loadingState == .initial)
        await aopdListViewModel.viewAppeared()
        XCTAssertTrue(aopdListViewModel.astronomyPics.count == 0)
        XCTAssertTrue(aopdListViewModel.loadingState == .initial)
        XCTAssertTrue(aopdListViewModel.showAlert)
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
