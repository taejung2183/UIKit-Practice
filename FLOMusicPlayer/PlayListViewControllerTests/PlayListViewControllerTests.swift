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
		
		XCTAssertNotNil(sut.tableView)
		XCTAssertEqual(sut.tableView.superview, view)
	}
	
	func test_tableView_configuration() {
		let tableView = sut.tableView
		
		sut.loadViewIfNeeded()
		
		let config =
			tableView.allowsSelection &&
			tableView.isUserInteractionEnabled &&
			!tableView.translatesAutoresizingMaskIntoConstraints
		
		XCTAssertTrue(config)
	}

	func test_tableView_covers_entire_superView() {
		let tableView = sut.tableView
		let superView = sut.view!
		
		sut.loadViewIfNeeded()

		XCTAssertTrue(tableView.frame == superView.bounds)
	}
	
	func test_setting_DataSource() {
		let dataSource = PlayListDataSource(music: [])
		sut.dataSource = dataSource
		
		sut.loadViewIfNeeded()
		
		XCTAssertTrue(sut.tableView.dataSource === dataSource)
	}
}
