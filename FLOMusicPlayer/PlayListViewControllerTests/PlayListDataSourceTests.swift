//
//  PlayListDataSourceTests.swift
//  PlayListViewControllerTests
//
//  Created by atj on 2021/09/29.
//

import XCTest
@testable import FLOMusicPlayer

class PlayListDataSourceTests: XCTestCase {
	
	func test_has_one_section() {
		let sut = PlayListDataSource(music: [])
		
		let tableView = UITableView()
		tableView.dataSource = sut
		
		let numOfSections = tableView.numberOfSections
		
		// The default behavior of UITableView is to have one section.
		// But we will keep this test before we need another numbers of sections.
		XCTAssertEqual(numOfSections, 1)
	}
	
	func test_numbers_of_rows_are_the_music_count() {
		let music: [Music] = [
			Music(singer: "one", album: "one", title: "one", duration: 1, image: "one", file: "one", lyrics: "one"),
			Music(singer: "two", album: "two", title: "two", duration: 2, image: "two", file: "two", lyrics: "two")
		]
		
		let sut = PlayListDataSource(music: music)
		
		let tableView = UITableView()
		tableView.dataSource = sut
		
		let numOfRows = tableView.numberOfRows(inSection: 0)
		
		XCTAssertEqual(numOfRows, music.count)
	}
}

