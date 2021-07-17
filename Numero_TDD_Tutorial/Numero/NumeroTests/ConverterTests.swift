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
	func testConverstionForZero() {
		let result = converter.convert(0)
		// Zero isn't represented in Roman numerals.
		XCTAssertEqual(result, "", "Conversion for 0 is incorrect")
	}
	func testConverstionFor3999() {
		let result = converter.convert(3999)
		XCTAssertEqual(result, "MMMCMXCIX", "Conversion for 3999 is incorrect")
	}
	func testConverstionFor40() {
		let result = converter.convert(40)
		XCTAssertEqual(result, "XL", "Conversion for 40 is incorrect")
	}
	func testConverstionFor50() {
		let result = converter.convert(50)
		XCTAssertEqual(result, "L", "Conversion for 50 is incorrect")
	}
	func testConverstionFor100() {
		let result = converter.convert(100)
		XCTAssertEqual(result, "C", "Conversion for 100 is incorrect")
	}
	func testConverstionFor400() {
		let result = converter.convert(400)
		XCTAssertEqual(result, "CD", "Conversion for 400 is incorrect")
	}
	func testConverstionFor500() {
		let result = converter.convert(500)
		XCTAssertEqual(result, "D", "Conversion for 500 is incorrect")
	}
}
