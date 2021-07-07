/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import XCTest
@testable import BullsEye

class BullsEyeSlowTests: XCTestCase {
	var sut: URLSession!
	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
		try super.setUpWithError()
		sut = URLSession(configuration: .default)
	}
	
	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		sut = nil
		try super.tearDownWithError()
	}
	
	func testValidApiCallGetsHTTPStatusCode200() throws {
		// given
		let urlString = "http://www.randomnumberapi.com/api/v1.0/random?min=0&max=100&count=1"
		let url = URL(string: urlString)!
		// 1: expectation() Returns XCTestExpectation. description describes what you expect to happen.
		let promise = expectation(description: "Status code: 200")
		
		// when
		let dataTask = sut.dataTask(with: url) { _, response, error in
			// then
			if let error = error {
				XCTFail("Error: \(error.localizedDescription)")
				return
			} else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
				if statusCode == 200 {
					// 2: Call fulfill() in the success condition closure of the asynchronous method's completion handler to flag that the expectation has been met.
					promise.fulfill()
				} else {
					XCTFail("Status code: \(statusCode)")
				} 
			}
		}
		dataTask.resume()
		// 3: Keeps the test running until all expectations are fulfilled or the timeout interval ends, whichever happens first.
		wait(for: [promise], timeout: 5)
	}
	
	func testExample() throws {
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct results.
	}
	
	func testPerformanceExample() throws {
		// This is an example of a performance test case.
		measure {
			// Put the code you want to measure the time of here.
		}
	}
}
