//
//  FLOMusicPlayerURLParsingTests.swift
//  FLOMusicPlayerURLParsingTests
//
//  Created by atj on 2021/07/28.
//

import XCTest
@testable import FLOMusicPlayer

class FLOMusicPlayerNetworkingTests: XCTestCase {
	let networkMonitor = NetworkMonitor.shared
	var sut: URLSession!
	var mockedSession: URLSessionMock!
	var webService: WebServices!

	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = URLSession(configuration: .default)
		mockedSession = URLSessionMock(data: nil, urlResponse: nil, error: nil)
		webService = WebServices(through: mockedSession)
	}
	
	override func tearDownWithError() throws {
		sut = nil
		mockedSession = nil
		webService = nil
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
	
	func testDownloadFunctionGetsURLProperly() {
		// given
		let mockedURLSession = URLSessionMock(data: nil,urlResponse: nil,error: nil)
		webService.session = mockedURLSession
		let url = "http://catchmeifyoucan.testUrl.com/thispath/aswell"

		// when you feed the url to the downloadData() function,
		webService.downloadData(from:url) { data, error in }
		
		// then the mocked session in webService instance
		// should get the exact same url.
		XCTAssertEqual(mockedURLSession.cachedUrl?.host, "catchmeifyoucan.testUrl.com")
		XCTAssertEqual(mockedURLSession.cachedUrl?.path, "/thispath/aswell")
	}
	
	func testDownloadFunctionBringsCorrectData() {
		// GIVEN
		
		// Parse mocked jason data from bundle.
		guard let path = Bundle.main.path(forResource: "MockedData", ofType: "json") else { return }
		guard let jsonString = try? String(contentsOfFile: path) else { return }
		let data = jsonString.data(using: .utf8)

		// Feed the mocked jason data to the mocked URLSession.
		let mockedURLSession = URLSessionMock(data: data, urlResponse: nil, error: nil)
		webService.session = mockedURLSession
		let url = "https://arbitraryURL.com/path"
		let exp = expectation(description: "music")
		var response: Music?

		// WHEN you call downloadData() fuction, you can retreive
		// the music data that you've passed through the mocked url session.
		webService.downloadData(from: url) { data, error in
			if let data = data {
				let music: Music
				
				do {
					music = try JSONDecoder().decode(Music.self, from: data)
				} catch {
					fatalError("ERROR INFO : \(error)")
				}
				
				response = music
			}
			exp.fulfill()
		}

		// THEN
		waitForExpectations(timeout: 1) { error in
			guard let response = response else { return }
			XCTAssertEqual(response.singer, "Terry Reid");
		}
	}
	
	func testGetErrorProperly() {
		// given
		let error = NSError(domain: "error", code: 1234, userInfo: nil)
		let mockedURLSession = URLSessionMock(data: nil, urlResponse: nil, error: error)
		webService.session = mockedURLSession
		let url = "https://arbitraryURL.com/path"
		let exp = expectation(description: "error")
		var errorResponse: Error?
		
		// when
		webService.downloadData(from: url) { data, error in
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
		webService.session = mockedURLSession
		let url = "https://arbitraryURL.com/path"
		let exp = expectation(description: "Error for empty data")
		var emptyResponse: Error?
		
		// when
		webService.downloadData(from: url) { data, error in
			emptyResponse = error
			exp.fulfill()
		}
		
		// then
		waitForExpectations(timeout: 1) { error in
			XCTAssertNotNil(emptyResponse)
		}
	}
	
	func testBadResponseReturnsError() {
		// GIVEN
		
		// Create valid data and invalid url response.
		// I just need invalid statusCode. Take any number except 200...299.
		let jsonString = "valid : data"
		let data = jsonString.data(using: .utf8)
		let badResponse = HTTPURLResponse(url: URL(string: "https://fakeurl.com/path")!, statusCode: 444, httpVersion: "1", headerFields: nil)!
		
		let mockedURLSession = URLSessionMock(data: data, urlResponse: badResponse, error: nil)
		webService.session = mockedURLSession
		let url = "https://FakeURL.com/path"
		let exp = expectation(description: "Error for invalid status code")
		var response: Error?
		
		// WHEN
		webService.downloadData(from: url) { data, error in
			response = error
			exp.fulfill()
		}

		// THEN
		waitForExpectations(timeout: 1) { error in
			XCTAssertNotNil(response)
		}
	}
}