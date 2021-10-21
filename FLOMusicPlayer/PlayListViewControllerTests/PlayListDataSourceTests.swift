//
//  PlayListDataSourceTests.swift
//  PlayListViewControllerTests
//
//  Created by atj on 2021/09/29.
//

import XCTest
@testable import FLOMusicPlayer

class PlayListDataSourceTests: XCTestCase {
	private var sut: PlayListDataSource!
	private var music: [Music]!
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		music = [
			Music(singer: "David Bowie", album: "The Rise and Fall of Ziggy Stardust", title: "Ziggy Stardust", duration: 220, image: "DavidBowie", file: "empty", lyrics: "some lyrics")
		]
		sut = PlayListDataSource(music: music)
	}
	
	override func tearDownWithError() throws {
		sut = nil
		music = nil
		try super.tearDownWithError()
	}
	
	func setTableView() -> UITableView {
		let tableView = UITableView()
		tableView.dataSource = sut
		return tableView
	}

	func test_has_one_section() {
		// GIVEN data source.

		// WHEN you create table view with given data source,
		let tableView = setTableView()

		// THEN there should be one section.
		// The default behavior of UITableView is to have one section.
		// But we will keep this test before we need another numbers of sections.
		let numOfSections = tableView.numberOfSections
		XCTAssertEqual(numOfSections, 1)
	}
	
	func test_numbers_of_rows_are_the_music_count() {
		// GIVEN data source.

		// WHEN you create table view with given data source,
		let tableView = setTableView()

		// THEN there should be music.count numbers of rows.
		let numOfRows = tableView.numberOfRows(inSection: 0)
		XCTAssertEqual(numOfRows, music.count)
	}
	
//	func test_show_data_for_rows_correctly() {
//		// GIVEN data source.
//
//		// WHEN you create table view with given data source and register reusable cell,
//		let tableView = setTableView()
//		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MusicCell")
//		tableView.reloadData()
//
//		// THEN there should be correct data on the correct cell.
//		let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
//		XCTAssertEqual("one", cell?.textLabel?.text)
//	}
	
	func test_configure_cell_correctly() {
		// GIVEN data source.

		// WHEN you create table view with given data source and register reusable cell,
		let tableView = setTableView()
		tableView.register(MusicCell.self, forCellReuseIdentifier: "MusicCell")
		tableView.reloadData()

		// THEN there should be correct data on the correct cell.
		if let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MusicCell {
			XCTAssertEqual(cell.titleLabel.text, "Ziggy Stardust")
			XCTAssertEqual(cell.artistLabel.text, "David Bowie")
			XCTAssertEqual(cell.albumImage.image, UIImage(named: "DavidBowie"))
		}
	}
	
	func test_register_reusable_cell() {
		// GIVEN data source.
		
		// WHEN you create PlayListViewController instance with the data source
		let vc = PlayListViewController()
		vc.dataSource = sut
		vc.loadViewIfNeeded()
		
		// and get the tableView.
		let tableView = vc.tableView
		tableView.reloadData()

		// THEN the tableView cell should have reusable cell with the identifier.
		let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
		XCTAssertEqual("MusicCell", cell?.reuseIdentifier)
	}
}
