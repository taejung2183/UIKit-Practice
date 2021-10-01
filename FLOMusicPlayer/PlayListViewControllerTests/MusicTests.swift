//
//  MusicTests.swift
//  PlayListViewControllerTests
//
//  Created by atj on 2021/10/01.
//

import XCTest
@testable import FLOMusicPlayer

class MusicTests: XCTestCase {
	
	func test_music_class_with_required_field() {
		// Given the music variable of type Music.
		let music: Music
		
		// WHEN you instantiate.
		music = Music(singer: "singer", album: "album", title: "title", duration: 0, image: "image", file: "file", lyrics: "lyrics")

		// THEN the properies should have the same value.
		XCTAssertEqual(music.singer, "singer")
		XCTAssertEqual(music.album, "album")
		XCTAssertEqual(music.title, "title")
		XCTAssertEqual(music.duration, 0)
		XCTAssertEqual(music.image, "image")
		XCTAssertEqual(music.file, "file")
		XCTAssertEqual(music.lyrics, "lyrics")
	}
}
