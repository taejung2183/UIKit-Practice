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
	var webService = WebServices(through: URLSessionMock(data: nil, urlResponse: nil, error: nil))

	func testValidUrl() throws {
		
		// Skip the test when no network is reachable.
		try XCTSkipUnless(networkMonitor.isReachable, "Bad network connection")
		
		// Given
		let url = URL(string: "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json")!
		let exp = expectation(description: "Completion handler invoked")
		var statusCode: Int?
		var responseError: Error?
		
		// when
		let session = URLSession(configuration: .default)
		let dataTask = session.dataTask(with: url) { _, response, error in
			statusCode = (response as? HTTPURLResponse)?.statusCode
			responseError = error
			exp.fulfill()
		}
		dataTask.resume()
		wait(for: [exp], timeout: 2)
		
		// then
		XCTAssertNil(responseError)
		XCTAssertEqual(statusCode, 200)
	}
	
	func testDownloadFunctionGetsURLProperly() {
		// given
		let mockedURLSession = prepareURLSession(nil, nil, nil)
		webService.session = mockedURLSession
		let host = "catchmeifyoucan.testUrl.com"
		let path = "/thispath/aswell"

		// when you feed the url to the downloadData() function,
		webService.downloadData(from: "http://" + host + path) { data, error in }
		
		// then the mocked session in webService instance should get the exact same url.
		XCTAssertEqual(mockedURLSession.cachedUrl?.host, host)
		XCTAssertEqual(mockedURLSession.cachedUrl?.path, path)
	}
	
	func testDownloadFunctionBringsCorrectData() {
		// GIVEN
		
		guard let jsonString = try? String(contentsOfFile: Bundle.main.path(forResource: "MockedData", ofType: "json")!) else { return }
		webService.session = prepareURLSession(
			jsonString.data(using: .utf8),
			HTTPURLResponse(url: URL(string: "https://arbitrary-url.com/path")!, statusCode: 200, httpVersion: "1", headerFields: nil)!,
			nil
		)
		
		let url = "https://arbitraryURL.com/path"
		let exp = expectation(description: "music")
		var retrievedData: Music?

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
				
				retrievedData = music
			}
			exp.fulfill()
		}

		// THEN
		waitForExpectations(timeout: 1) { error in
			guard let retrievedData = retrievedData else { return }
			XCTAssertEqual(retrievedData.singer, "Terry Reid");
		}
	}
	
	func testBadResponseReturnsError() {
		
		// Given that the session has proper data without error but it's got an invalid response,
		// Make valid data with invalid url response. Take any number except 200...299 for the invalid response.
		webService.session = prepareURLSession(
			"valid : data".data(using: .utf8),
			HTTPURLResponse(url: URL(string: "https://fakeurl.com/path")!, statusCode: 444, httpVersion: "1", headerFields: nil)!,
			nil
		)
		
		// When request a networking with the invalid response,
		let error = requestNetworking(
			to: "https://arbitrary-url.com/path",
			for: expectation(description: "Error for invalid status code")
		)
		
		// Then there should be an error.
		XCTAssertNotNil(error)
	}
	
	func testGetErrorProperly() {
		
		// Given that the session is set up with a proper data and response but it's got an error,
		webService.session = prepareURLSession(
			"random data".data(using: .utf8),
			HTTPURLResponse(url: URL(string: "https://arbitraryurl.com/path")!, statusCode: 200, httpVersion: "1", headerFields: nil)!,
			NSError(domain: "error", code: 1234, userInfo: nil)
		)
		
		// When you request a networking with an errornous session,
		let error = requestNetworking(
			to: "https://arbitrary-url.com/path",
			for: expectation(description: "Error for errornous session.")
		)
		
		// Then there should be an error.
		XCTAssertNotNil(error)
	}
	
	func testNilDataReturnsError() {
		
		// Given that the session has proper response without error but it's got nil data,
		webService.session = prepareURLSession(
			nil,
			HTTPURLResponse(url: URL(string: "https://arbitraryurl.com/path")!, statusCode: 200, httpVersion: "1", headerFields: nil)!,
			nil
		)

		// When you request a networking with a nil data,
		let error = requestNetworking(
			to: "https://arbitrary-url.com/path",
			for: expectation(description: "Error for nil data.")
		)
		
		// Then there should be an error.
		XCTAssertNotNil(error)
	}
	
	func testEmptyDataReturnsError() {
		
		// Given that the data is empty string,
		webService.session = prepareURLSession(
			"".data(using: .utf8),
			HTTPURLResponse(url: URL(string: "https://arbitraryurl.com/path")!, statusCode: 200, httpVersion: "1", headerFields: nil)!,
			nil
		)
		
		// When you request a networking with an empty string data,
		let error = requestNetworking(
			to: "https://arbitrary-url.com/path",
			for: expectation(description: "Error for nil data.")
		)
		
		// Then there should be an error.
		XCTAssertNotNil(error)
	}
	
	// - MARK - : Helper methods
	
	func prepareURLSession(_ data: Data?, _ response: URLResponse?, _ error: NSError?) -> URLSessionMock {
		return URLSessionMock(data: data, urlResponse: response, error: error)
	}
	
	func requestNetworking(to url: String, for exp: XCTestExpectation) -> Error? {
		var response: Error?
		
		webService.downloadData(from: url) { data, error in
			response = error
			exp.fulfill()
		}
		
		waitForExpectations(timeout: 1) { error in
			print("Got the response.")
		}
		
		return response
	}
}
