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
			Music(singer: "one", album: "", title: "", duration: 0, image: "", file: "", lyrics: "")
		]
		
		let sut = PlayListDataSource(music: music)
		
		let tableView = UITableView()
		tableView.dataSource = sut
		
		let numOfRows = tableView.numberOfRows(inSection: 0)
		
		XCTAssertEqual(numOfRows, music.count)
	}
	
	func test_show_data_for_rows_correctly() {
		let music: [Music] = [
			Music(singer: "one", album: "", title: "", duration: 0, image: "", file: "", lyrics: "")
		]
		
		let sut = PlayListDataSource(music: music)
		
		let tableView = UITableView()
		tableView.dataSource = sut
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: PlayListDataSource.identifier)
		tableView.reloadData()

		let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))

		XCTAssertEqual("one", cell?.textLabel?.text)
	}
	
	func test_register_reusable_cell() {
		let music: [Music] = [
			Music(singer: "one", album: "", title: "", duration: 0, image: "", file: "", lyrics: "")
		]
		
		let sut = PlayListDataSource(music: music)
		let vc = PlayListViewController()
		vc.dataSource = sut
		vc.loadViewIfNeeded()
		
		let tableView = vc.tableView
		tableView.reloadData()

		let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))

		XCTAssertEqual(PlayListDataSource.identifier, cell?.reuseIdentifier)
	}
}
