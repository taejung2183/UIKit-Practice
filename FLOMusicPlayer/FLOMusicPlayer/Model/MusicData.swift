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

class MusicData<T: URLSessionProtocol> {
	var session: T?
	func getMusic(from urlStr: String, completion: @escaping (Music?, Error?) -> Void) {
		guard let url = URL(string: urlStr)
		else { fatalError() }
		
		guard let session = session else { return }
		let dataTask = session.myDataTask(with: url) { data, response, error in
			guard error == nil else {
				completion(nil, error)
				return
			}
			
			// Return with error for nil data
			guard let data = data else {
				completion(nil, NSError(domain: "Empty data", code: 10, userInfo: nil))
				return
			}
			
			// Empty data
			if data.isEmpty {
				completion(nil, NSError(domain: "Empty data", code: 10, userInfo: nil))
				return
			}

			// Check if data is valid json data
			do {
				let music = try JSONDecoder().decode(Music.self, from: data)
				completion(music, nil)
			} catch {
				completion(nil, error)
			}
		}
		dataTask.resume()
	}
}

