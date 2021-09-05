//
//  PlayListViewControllerTests.swift
//  PlayListViewControllerTests
//
//  Created by atj on 2021/08/30.
//

import XCTest
@testable import FLOMusicPlayer

class PlayListViewControllerTests: XCTestCase {
	private var vc: PlayListViewController!
	private var view: UIView!
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		vc = PlayListViewController()
		view = vc.view
	}
	
	override func tearDownWithError() throws {
		vc = nil
		view = nil
		try super.tearDownWithError()
	}
	
	func test_is_root_viewController() {
		guard let rootVC = UIApplication.shared.windows.first!.rootViewController else { return }
		
		// Check if the rootVC is an instance of the class of vc,
		// which is PlayListViewController
		XCTAssert(rootVC.isKind(of: type(of: vc)))
	}
	
	func test_has_tableView() {
		XCTAssertNotNil(vc.tableView)
		XCTAssertEqual(vc.tableView.superview, view)
	}
}
