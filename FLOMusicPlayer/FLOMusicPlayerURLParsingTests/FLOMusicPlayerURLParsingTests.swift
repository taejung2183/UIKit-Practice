//
//  FLOMusicPlayerURLParsingTests.swift
//  FLOMusicPlayerURLParsingTests
//
//  Created by atj on 2021/07/28.
//

import XCTest
@testable import FLOMusicPlayer

class FLOMusicPlayerURLParsingTests: XCTestCase {
	let networkMonitor = NetworkMonitor.shared
	var sut: URLSession!
	var musicData: MusicData<URLSessionMock>!

	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = URLSession(configuration: .default)
		musicData = MusicData()
	}
	
	override func tearDownWithError() throws {
		sut = nil
		musicData = nil
		try super.tearDownWithError()
	}
	
	func testValidUrl() throws {
		// Skip the test when no network is reachable.
		try XCTSkipUnless(networkMonitor.isReachable, "Bad network connection")
		// given
		let urlString = "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json"
		let url = URL(string: urlString)!
		let promise = expectation(description: "Completion handler invoked")
		var statusCode: Int?
		var responseError: Error?
		
		// when
		let dataTask = sut.dataTask(with: url) { _, response, error in
			statusCode = (response as? HTTPURLResponse)?.statusCode
			responseError = error
			// Simply entering this completion handler fulfills the expectation, and it makes this test no longer waits for the extra seconds.
			// But still, it'll fail at the then clause because the request failed.
			promise.fulfill()
		}
		dataTask.resume()
		wait(for: [promise], timeout: 5)
		
		// then
		XCTAssertNil(responseError)
		XCTAssertEqual(statusCode, 200)
	}
	
	func testGetMusicFunctionWithExpectedURLHostAndPath() {
		// given that the instance of a MusicData has
		// a mocked url session, and with the url.
		let mockedURLSession = URLSessionMock(data: nil,urlResponse: nil,error: nil)
		musicData.session = mockedURLSession
		let url = "http://catchmeifyoucan.testUrl.com/thispath/aswell"

		// when you feed the url to the getMusic() function,
		musicData.getMusic(from: url) { music, data in }
		
		// then the mocked session in musicData instance
		// should get the exact same url.
		XCTAssertEqual(mockedURLSession.cachedUrl?.host, "catchmeifyoucan.testUrl.com")
		XCTAssertEqual(mockedURLSession.cachedUrl?.path, "/thispath/aswell")
	}
	
	func testGetCorrectMusicData() {
		// given
		
		// Parse mocked jason data from bundle.
		guard let path = Bundle.main.path(forResource: "MockedData", ofType: "json") else { return }
		guard let jsonString = try? String(contentsOfFile: path) else { return }
		let data = jsonString.data(using: .utf8)

		// Feed the mocked jason data to the mocked URLSession.
		let mockedURLSession = URLSessionMock(data: data, urlResponse: nil, error: nil)
		musicData.session = mockedURLSession
		let url = "https://arbitraryURL.com/path"
		let exp = expectation(description: "music")
		var response: Music?

		// when you call getMusic() fuction, you can retreive
		// the music data that you've passed through the mocked url session.
		musicData.getMusic(from: url) { music, error in
			response = music
			exp.fulfill()
		}

		// then
		waitForExpectations(timeout: 1) { error in
			guard let response = response else { return }
			XCTAssertEqual(response.singer, "Terry Reid");
		}
	}
	
	func testGetErrorProperly() {
		// given
		let error = NSError(domain: "error", code: 1234, userInfo: nil)
		let mockedURLSession = URLSessionMock(data: nil, urlResponse: nil, error: error)
		musicData.session = mockedURLSession
		let url = "https://arbitraryURL.com/path"
		let exp = expectation(description: "error")
		var errorResponse: Error?
		
		// when
		musicData.getMusic(from: url) { music, error in
			errorResponse = error
			exp.fulfill()
		}
		
		// then
		waitForExpectations(timeout: 1) { error in
			XCTAssertNotNil(errorResponse)
		}
	}
	
	func testEmptyDataReturnsError() {
		// given
		
		// Create fake empty data
		let jsonString = ""
		let data = jsonString.data(using: .utf8)
		
		// Feed the empty data to the URLSessionMock
		let mockedURLSession = URLSessionMock(data: data, urlResponse: nil, error: nil)
		musicData.session = mockedURLSession
		let url = "https://arbitraryURL.com/path"
		let exp = expectation(description: "Error for empty data")
		var emptyResponse: Error?
		
		// when
		musicData.getMusic(from: url) { music, error in
			emptyResponse = error
			exp.fulfill()
		}
		
		// then
		waitForExpectations(timeout: 1) { error in
			XCTAssertNotNil(emptyResponse)
		}
	}
	
	func testInvalidJsonDataReturnsError() {
		// given
		
		// Create invalid json data
		let jsonString = "INVALID"
		let data = jsonString.data(using: .utf8)
		
		let mockedURLSession = URLSessionMock(data: data, urlResponse: nil, error: nil)
		musicData.session = mockedURLSession
		let url = "https://arbitraryURL.com/path"
		let exp = expectation(description: "Error for invalid json data")
		var invalidJsonResponse: Error?

		// when
		musicData.getMusic(from: url) { music, error in
			invalidJsonResponse = error
			exp.fulfill()
		}

		// then
		waitForExpectations(timeout: 1) { error in
			XCTAssertNotNil(invalidJsonResponse)
		}
	}
	
}
















