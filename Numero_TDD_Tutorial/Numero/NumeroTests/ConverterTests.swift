//
//  ConverterTests.swift
//  NumeroTests
//
//  Created by atj on 2021/07/16.
//  Copyright © 2021 Facebook. All rights reserved.
//

import XCTest
@testable import Numero

class ConverterTests: XCTestCase {
	let converter = Converter()
	
	override func setUpWithError() throws {}
	override func tearDownWithError() throws {}
	
	func testConversionForOne() {
		let result = converter.convert(1)
		XCTAssertEqual(result, "I", "Conversion for 1 is incorrect")
	}
	func testConversionForTwo() {
		let result = converter.convert(2)
		XCTAssertEqual(result, "II", "Conversion for 2 is incorrect")
	}
	func testConversionForFive() {
		let result = converter.convert(5)
		XCTAssertEqual(result, "V", "Conversion for 5 is incorrect")
	}
	func testConversionForSix() {
		let result = converter.convert(6)
		XCTAssertEqual(result, "VI", "Conversion for 6 is incorrect")
	}
	func testConversionForTen() {
		let result = converter.convert(10)
		XCTAssertEqual(result, "X", "Conversion for 10 is incorrect")
	}
	func testConversionForTwenty() {
		let result = converter.convert(20)
		XCTAssertEqual(result, "XX", "Conversion for 20 is incorrect")
	}
	func testConversionForFour() {
		let result = converter.convert(4)
		XCTAssertEqual(result, "IV", "Conversion for 4 is incorrect")
	}
	func testConversionForNine() {
		let result = converter.convert(9)
		XCTAssertEqual(result, "IX", "Conversion for 9 is incorrect")
	}

}
