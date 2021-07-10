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

// Let's use a mock object to test that your code correctly updates UserDefaults.

class MockUserDefaults: UserDefaults {
	var gameStyleChanged = 0;
	override func set(_ value: Int, forKey defaultName: String) {
		if defaultName == "gameStyle" {
			gameStyleChanged += 1
		}
	}
}

class BullsEyeMockTests: XCTestCase {
	var sut: ViewController!
	// Mock object
	var mockUserDefaults: MockUserDefaults!

	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = UIStoryboard(name: "Main", bundle: nil)
			.instantiateInitialViewController() as? ViewController
		mockUserDefaults = MockUserDefaults(suiteName: "testing")
		// Inject the mock object as a property of the SUT.
		sut.defaults = mockUserDefaults
	}

	override func tearDownWithError() throws {
		sut = nil
		mockUserDefaults = nil
		try super.tearDownWithError()
	}
	
	func testGameStyleCanBeChanged() {
		// given
		let segmentedControl = UISegmentedControl()

		// when
		XCTAssertEqual(mockUserDefaults.gameStyleChanged, 0, "gameStyleChanged should be 0 before sendActions")
		segmentedControl.addTarget(
			sut,
			action: #selector(ViewController.chooseGameStyle(_:)),
			for: .valueChanged)
		segmentedControl.sendActions(for: .valueChanged)

		// then
		XCTAssertEqual(
			mockUserDefaults.gameStyleChanged,
			1,
			"gameStyle user default wasn't changed")
	}

	func testExample() throws {
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct results.
	}
	
	func testPerformanceExample() throws {
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}
}
