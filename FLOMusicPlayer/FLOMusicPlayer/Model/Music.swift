//
//  Music.swift
//  FLOMusicPlayer
//
//  Created by atj on 2021/08/09.
//

import Foundation

class Music: Codable {
	let singer: String
	let album: String
	let title: String
	let duration: Int
	let image: String
	let file: String
	let lyrics: String

	init(singer: String, album: String, title: String, duration: Int, image: String, file: String, lyrics: String) {
		self.singer = singer
		self.album = album
		self.title = title
		self.duration = duration
		self.image = image
		self.file = file
		self.lyrics = lyrics
	}
}
