//
//  PlayListViewControllerTests.swift
//  PlayListViewControllerTests
//
//  Created by atj on 2021/08/30.
//

import XCTest
@testable import FLOMusicPlayer

class PlayListViewControllerTests: XCTestCase {
	var vc: PlayListViewController!
	private var view: UIView?
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		vc = PlayListViewController()
		view = vc?.view
	}
	
	override func tearDownWithError() throws {
		vc = nil
		view = nil
		try super.tearDownWithError()
	}
}
