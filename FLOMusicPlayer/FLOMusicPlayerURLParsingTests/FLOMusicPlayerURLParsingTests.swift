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

	override func setUpWithError() throws {
		try super.setUpWithError()
		sut  = URLSession(configuration: .default)
	}
	
	override func tearDownWithError() throws {
		sut = nil
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
	
	func testMockedURLSessionDataTask() {
		// given
		let mockedSession = URLSessionMock()
		mockedSession.data = "fakeData".data(using: .ascii)
		let url = URL(string: "http://FakeURL.com")
		let musicData = MusicData()
		let exp = expectation(description: "Loading URL")
		
		// when you download data
		musicData.downloadData(mockedSession, completionBlock: { data in
			exp.fulfill()
		})
		waitForExpectations(timeout: 0.1)
		
		// then you should get the data
		XCTAssertEqual(musicData.data, "fakeData".data(using: .ascii))
	}
}
