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
// This gives access to the internal types and functions in BullsEye.
@testable import BullsEye

class BullsEyeTests: XCTestCase {
	// Create placeholder for BullsEyeGame, which is the System Under Test (SUT) or the object this test case class is concerned with testing.
	var sut: BullsEyeGame!
	
	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
		// Create BullsEyeGame at the class level, so all the tests in this test class can access the SUT object's properties and methods.
		try super.setUpWithError()
		sut = BullsEyeGame()
	}
	
	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		// It's good practice creating the SUT in setUpWithError() and releasing it in tearDownWithError() to ensure every test starts with a clean state.
		sut = nil
		try super.tearDownWithError()
	}
	
	// A test method's name always begins with test, followed by a description of waht it tests.
	func testScoreIsComputedWhenGuessIsHigherThanTarget() {
		// Practice to format the test into give, when and then sections.
		// given: Set up any values needed.
		let guess = sut.targetValue + 5
		
		// when: Execute the code being tested.
		sut.check(guess: guess)
		
		// then: You'll assert the result you expect with a message that prints if the test fails.
		XCTAssertEqual(sut.scoreRound, 95, "Score computed from guess is wrong")
	}
	
	func testScoreIsComputedWhenGuessIsLowerThanTarget() {
		// given
		let guess = sut.targetValue - 5
		
		// when
		sut.check(guess: guess)
		
		// then
		XCTAssertEqual(sut.scoreRound, 95, "Score computed from guess is wrong")
	}
	
	// Performance test
	// Performance test is simple: Just place the code you want to measure into the closure of measure(). You can specify multiple metrics to measure.
	func testScoreIsComputedPerformance() {
		measure(metrics: [XCTClockMetric(), XCTCPUMetric(), XCTStorageMetric(), XCTMemoryMetric()]) {
			sut.check(guess: 100)
		}
	}
}
