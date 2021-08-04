//
//  MusicData.swift
//  FLOMusicPlayer
//
//  Created by atj on 2021/07/31.
//

import Foundation

struct Music: Codable {
	let singer: String
	let album: String
	let title: String
	let duration: Int
	let image: String
	let file: String
	let lyrics: String
}

class MusicData {
	var session: URLSessionProtocol!
	func getMusic(from urlStr: String, completion: @escaping (Music?, Error?) -> Void) {
		guard let url = URL(string: urlStr)
		else { fatalError() }
		
		let dataTask = session.dataTask(with: url) { data, response, error in
			guard let data = data else { return }
			let music = try! JSONDecoder().decode(Music.self, from: data)
			completion(music, nil)
		}
		dataTask.resume()
	}
}


