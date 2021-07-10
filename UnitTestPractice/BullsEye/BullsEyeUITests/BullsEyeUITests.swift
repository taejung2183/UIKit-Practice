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

class BullsEyeUITests: XCTestCase {
	var app: XCUIApplication!
	
	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
		// In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
		try super.setUpWithError()
		// In UI tests it is usually best to stop immediately when a failure occurs.
		continueAfterFailure = false
		app = XCUIApplication()
		app.launch()
	}
	
	func testGameStyleSwitch() {
		// Record your interactions with the red button at the left bottom.
		// tap the Slide segment of the game style switch and the top label.
		// Than the recorder creates code to test the same actions you tested in the app.
		// You'll use those as a base to create your own UI test.

		// given
		let slideButton = app/*@START_MENU_TOKEN@*/.segmentedControls.buttons["Slide"]/*[[".segmentedControls.buttons[\"Slide\"]",".buttons[\"Slide\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
		let typeButton = app.segmentedControls.buttons["Type"]
		let slideLabel = app.staticTexts["Get as close as you can to: "]
		let typeLabel = app.staticTexts["Guess where the slider is: "]
		
		// then
		// Check whether the correct label exists when you tap() on each button in the segmented control.
		if slideButton.isSelected {
			XCTAssertTrue(slideLabel.exists)
			XCTAssertFalse(typeLabel.exists)
			
			typeButton.tap()
			XCTAssertTrue(typeLabel.exists)
			XCTAssertFalse(slideLabel.exists)
		}
		else if typeButton.isSelected {
			XCTAssertTrue(typeLabel.exists)
			XCTAssertFalse(slideLabel.exists)
			
			slideButton.tap()
			XCTAssertTrue(slideLabel.exists)
			XCTAssertFalse(typeLabel.exists)
		}
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func testExample() throws {
		// UI tests must launch the application that they test.
		let app = XCUIApplication()
		app.launch()
		
		// Use recording to get started writing UI tests.
		// Use XCTAssert and related functions to verify your tests produce the correct results.
	}
	
	func testLaunchPerformance() throws {
		if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
			// This measures how long it takes to launch your application.
			measure(metrics: [XCTApplicationLaunchMetric()]) {
				XCUIApplication().launch()
			}
		}
	}
}
