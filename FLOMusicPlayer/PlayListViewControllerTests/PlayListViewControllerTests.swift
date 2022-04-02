//
//  PlayListViewControllerTests.swift
//  PlayListViewControllerTests
//
//  Created by atj on 2021/08/30.
//

import XCTest
@testable import FLOMusicPlayer

class PlayListViewControllerTests: XCTestCase {
	private var sut: PlayListViewController!
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = PlayListViewController()
	}
	
	override func tearDownWithError() throws {
		sut = nil
		try super.tearDownWithError()
	}
	
	func test_is_root_viewController() {
		guard let rootVC = UIApplication.shared.windows.first!.rootViewController else { return XCTFail() }

		XCTAssertTrue(rootVC is PlayListViewController)
	}
	
	func test_has_tableView() {
		let view = sut.view
		
		XCTAssertTrue(sut.tableView is UITableView)
		XCTAssertEqual(sut.tableView.superview, view)
	}
	
	func test_tableView_configuration() {
		let tableView = sut.tableView
		
		sut.loadViewIfNeeded()
		
		let config =
			tableView.allowsSelection &&
			tableView.isUserInteractionEnabled &&
			!tableView.translatesAutoresizingMaskIntoConstraints &&
			tableView.rowHeight == 60
		
		XCTAssertTrue(config)
	}

	func test_tableView_covers_entire_superView() {
		let tableView = sut.tableView
		let superView = sut.view!
		
		sut.loadViewIfNeeded()

		XCTAssertTrue(tableView.frame == superView.bounds)
	}
	
	func test_setting_DataSource() {
		let dataSource = PlayListDataSource(musicArray: [], albumImageArray: [])
		sut.dataSource = dataSource
		
		sut.loadViewIfNeeded()
		
		XCTAssertTrue(sut.tableView.dataSource === dataSource)
	}

//	func test_getMusic_initialize_dataSource() {
//		sut.getMusic(from: "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json")
//		sut.loadViewIfNeeded()
//
//		print("Number of rows: \(sut.tableView.numberOfRows(inSection: 0))")
//		XCTAssertNotEqual(sut.tableView.numberOfRows(inSection: 0), 0)
//	}
	
//	func test_getMusic_initializes_dataSource_through_calling_network_api() {
//		// getMusic() should initialize the dataSource which is the sut's member variable.
//
//		// How can I force the getMusic() function to call network api?
//
//		// If I can get the specific of the data in advance, and test
//		// if it's equal to it, the only way to initialize the tableView
//		// is to call network api.
//
//		sut.getMusic(from: "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json")
//
//		XCTAssertNotEqual(sut.tableView.numberOfRows(inSection: 0), 0)
//	}
	
//	func test_viewDidLoad_calls_getMusic() {
//
//	}
		
//	func test_getMusic_is_called_when_initialized() {
//
//	}
}
