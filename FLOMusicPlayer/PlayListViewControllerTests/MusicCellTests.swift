//
//  MusicCellTests.swift
//  PlayListViewControllerTests
//
//  Created by atj on 2021/10/01.
//

import XCTest
@testable import FLOMusicPlayer

class MusicCellTests: XCTestCase {
	var sut: MusicCell!
	var contentView: UIView!
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = MusicCell()
		contentView = sut.contentView
	}
	
	override func tearDownWithError() throws {
		sut = nil
		contentView = nil
		try super.tearDownWithError()
	}

	// Make MusicCell class with static constant identifier.
	func test_MusicCell_class() {
		let vc = PlayListViewController()
		let music = [
			Music(singer: "one", album: "", title: "", duration: 0, image: "", file: "", lyrics: "")
		]
		vc.dataSource = PlayListDataSource(music: music)
		vc.loadViewIfNeeded()
		
		let cell = vc.tableView.dataSource?.tableView(vc.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
		
		XCTAssertTrue(cell is MusicCell)
		XCTAssertEqual(MusicCell.identifier, "MusicCell")
	}
	
	// MARK: UI Properties
	
	func test_imageView_on_the_MusicCell() {
		let imgView = sut.albumImage
		
		let config = imgView.image == UIImage(named: "placeholder") &&
			(imgView.contentMode == .scaleAspectFit) &&
			imgView.clipsToBounds

		XCTAssertTrue(config)
		XCTAssertEqual(imgView.superview, sut.contentView)
	}
	
	func test_titleLabel_on_the_MusicCell() {
		let titleLbl = sut.titleLabel
		
		let config = titleLbl.textColor == .black &&
			titleLbl.font == UIFont.systemFont(ofSize: 16, weight: .bold) &&
			titleLbl.textAlignment == .left &&
			titleLbl.text == "Title"
		// How to test drive lbl calling sizeToFit() ?

		XCTAssertTrue(config)
		XCTAssertEqual(titleLbl.superview, sut.contentView)
	}
	
	func test_artistLabel_on_the_MusicCell() {
		let artistLbl = sut.artistLabel
		
		let config = artistLbl.textColor == .black &&
			artistLbl.font == UIFont.systemFont(ofSize: 10) &&
			artistLbl.textAlignment == .left &&
			artistLbl.text == "Artist"

		XCTAssertTrue(config)
		XCTAssertEqual(artistLbl.superview, sut.contentView)
	}
	
	func test_moreButton_on_the_MusicCell() {
		let moreBtn = sut.moreButton

		let config = moreBtn.image(for: .normal) == UIImage(systemName: "ellipsis") &&
			moreBtn.tintColor == .black

		XCTAssertTrue(config)
		XCTAssertEqual(moreBtn.superview, sut.contentView)
	}
	
	// MARK: Constraints
	
	func test_imgView_constraints() {
		let imgView = sut.albumImage
		let contentView = sut.contentView
		
		sut.layoutIfNeeded()

		let constraints =
			!imgView.translatesAutoresizingMaskIntoConstraints &&
			imgView.frame.origin.x == contentView.frame.origin.x + 15 &&
			imgView.frame.midY == contentView.frame.midY &&
			imgView.frame.height == contentView.frame.height - 10 &&
			imgView.frame.width == contentView.frame.height
		
		XCTAssertTrue(constraints)
	}
	
	func test_titleLabel_constraints() {
		let imgView = sut.albumImage
		let titleLbl = sut.titleLabel
		let contentView = sut.contentView
		
		sut.layoutIfNeeded()
		
		let constraints =
			!titleLbl.translatesAutoresizingMaskIntoConstraints &&
			titleLbl.frame.origin.x == imgView.frame.maxX + 10 &&
			titleLbl.frame.origin.y == imgView.frame.origin.y &&
			titleLbl.frame.width == contentView.frame.width - 120

		XCTAssertTrue(constraints)
	}
	
	func test_artistLabel_constraints() {
		let imgView = sut.albumImage
		let titleLbl = sut.titleLabel
		let artistLbl = sut.artistLabel
		let contentView = sut.contentView
		
		sut.layoutIfNeeded()
		
		let constraints =
			!artistLbl.translatesAutoresizingMaskIntoConstraints &&
			artistLbl.frame.origin.x == imgView.frame.maxX + 10 &&
			artistLbl.frame.origin.y == titleLbl.frame.maxY + 2 &&
			artistLbl.frame.width == contentView.frame.width - 120

		XCTAssertTrue(constraints)
	}
	
	func test_moreButton_constraints() {
		let moreBtn = sut.moreButton
		let contentView = sut.contentView
		
		sut.layoutIfNeeded()
		
		let constraints =
			!moreBtn.translatesAutoresizingMaskIntoConstraints &&
			moreBtn.frame.maxX == contentView.frame.maxX - 20 &&
			moreBtn.frame.midY == contentView.frame.midY

		XCTAssertTrue(constraints)
	}

	// Configure the cell in the cellForRowAt indexPath method.
	

}
