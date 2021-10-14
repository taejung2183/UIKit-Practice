//
//  MusicCellTests.swift
//  PlayListViewControllerTests
//
//  Created by atj on 2021/10/01.
//

import XCTest
@testable import FLOMusicPlayer

class MusicCellTests: XCTestCase {
//	let cell = MusicCell()
//	var contentView: UIView!
//	var imgView: UIImageView!
//	var titleLbl: UILabel!
//	var artistLbl: UILabel!
//	var moreBtn: UIButton!

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
		let cell = MusicCell()
		let imgView = cell.albumImage
		
		let config = imgView.image == UIImage(named: "placeholder") &&
			(imgView.contentMode == .scaleAspectFit) &&
			imgView.clipsToBounds

		XCTAssertTrue(config)
		XCTAssertEqual(imgView.superview, cell.contentView)
	}
	
	func test_titleLabel_on_the_MusicCell() {
		let cell = MusicCell()
		let titleLbl = cell.titleLabel
		
		let config = titleLbl.textColor == .black &&
			titleLbl.font == UIFont.systemFont(ofSize: 16, weight: .bold) &&
			titleLbl.textAlignment == .left &&
			titleLbl.text == "Title"
		// How to test drive lbl calling sizeToFit() ?

		XCTAssertTrue(config)
		XCTAssertEqual(titleLbl.superview, cell.contentView)
	}
	
	func test_artistLabel_on_the_MusicCell() {
		let cell = MusicCell()
		let artistLbl = cell.artistLabel
		
		let config = artistLbl.textColor == .black &&
			artistLbl.font == UIFont.systemFont(ofSize: 10) &&
			artistLbl.textAlignment == .left &&
			artistLbl.text == "Artist"

		XCTAssertTrue(config)
		XCTAssertEqual(artistLbl.superview, cell.contentView)
	}
	
	func test_moreButton_on_the_MusicCell() {
		let cell = MusicCell()
		let moreBtn = cell.moreButton

		let config = moreBtn.image(for: .normal) == UIImage(systemName: "ellipsis") &&
			moreBtn.tintColor == .black

		XCTAssertTrue(config)
		XCTAssertEqual(moreBtn.superview, cell.contentView)
	}
	
	// MARK: Constraints
	
	func test_imgView_constraints() {
		let cell = MusicCell()
		let imgView = cell.albumImage
		let contentView = cell.contentView
		
		cell.layoutIfNeeded()

		let constraints =
			!imgView.translatesAutoresizingMaskIntoConstraints &&
			imgView.frame.origin.x == contentView.frame.origin.x + 15 &&
			imgView.frame.midY == contentView.frame.midY &&
			imgView.frame.height == contentView.frame.height - 10 &&
			imgView.frame.width == contentView.frame.height
		
		XCTAssertTrue(constraints)
	}
	
	func test_titleLabel_constraints() {
		let cell = MusicCell()
		let imgView = cell.albumImage
		let titleLbl = cell.titleLabel
		let contentView = cell.contentView
		
		cell.layoutIfNeeded()
		
		let constraints =
			!titleLbl.translatesAutoresizingMaskIntoConstraints &&
			titleLbl.frame.origin.x == imgView.frame.maxX + 10 &&
			titleLbl.frame.origin.y == imgView.frame.origin.y &&
			titleLbl.frame.width == contentView.frame.width - 120

		XCTAssertTrue(constraints)
	}
	
	func test_artistLabel_constraints() {
		let cell = MusicCell()
		let imgView = cell.albumImage
		let titleLbl = cell.titleLabel
		let artistLbl = cell.artistLabel
		let contentView = cell.contentView
		
		cell.layoutIfNeeded()
		
		let constraints =
			!artistLbl.translatesAutoresizingMaskIntoConstraints &&
			artistLbl.frame.origin.x == imgView.frame.maxX + 10 &&
			artistLbl.frame.origin.y == titleLbl.frame.maxY + 2 &&
			artistLbl.frame.width == contentView.frame.width - 120

		XCTAssertTrue(constraints)
	}
	
	func test_moreButton_constraints() {
		let cell = MusicCell()
		let moreBtn = cell.moreButton
		let contentView = cell.contentView
		
		cell.layoutIfNeeded()
		
		let constraints =
			!moreBtn.translatesAutoresizingMaskIntoConstraints &&
			moreBtn.frame.maxX == contentView.frame.maxX - 20 &&
			moreBtn.frame.midY == contentView.frame.midY

		XCTAssertTrue(constraints)
	}

	// Make public function to configure the cell by passing the image, title, artist value as an arguments from the cellForRowAt function in the PlayListDataSource.
	
	// Make prepareForReuse() function to deallocate UI elements for reusing.
	
	// Declare static constant string as an identifier, so that the view controller and the data source can use the identifier.
	
}
