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
			guard error == nil else {
				completion(nil, error)
				return
			}
			
			// empty is different from nil isn't it?
			guard let isEmptyData = data?.isEmpty else { return }
			if isEmptyData {
				let error = NSError(domain: "Empty data", code: 1234, userInfo: nil)
				completion(nil, error)
				return
			}

			guard let data = data else { return }
			let music = try! JSONDecoder().decode(Music.self, from: data)
			completion(music, nil)
		}
		dataTask.resume()
	}
}


