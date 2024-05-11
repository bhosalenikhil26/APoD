//
//  APIServiceTests.swift
//  AstroPicDailyTests
//
//  Created by Nikhil Bhosale on 2024-05-11.
//

import XCTest
@testable import AstroPicDaily

final class APIServiceTests: XCTestCase {
    private var mockAPIRequest: MockAPIRequest!
    private var apiService: MockAPIService!

    override func setUpWithError() throws {
        mockAPIRequest = MockAPIRequest()
        apiService = MockAPIService()
    }

    override func tearDownWithError() throws {
        mockAPIRequest = nil
        apiService = nil
    }

    func testExecuteRequest_whenURLIsNotPresent_shouldThrowInvalidUrlError() async {
        mockAPIRequest.url = nil
        do {
            _ = try await apiService.executeApiRequest(mockAPIRequest)
            XCTFail()
        } catch let error as APIError {
            XCTAssertTrue(error == APIError.invalidUrl)
        } catch {
            XCTFail()
        }
    }

    func testExecuteRequest_whenURLIsValid_shouldCallAPI() async {
        mockAPIRequest.url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&start_date=2024-05-11")
        do {
            let data = try await apiService.executeApiRequest(mockAPIRequest)
            XCTAssertNotNil(data)
        } catch {
            XCTFail()
        }
    }
}

private final class MockAPIRequest: APIRequest {
    var url: URL?
}

private final class MockAPIService: APIServiceProtocol {}
