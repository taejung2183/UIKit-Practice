//
//  MusicData.swift
//  FLOMusicPlayer
//
//  Created by atj on 2021/07/31.
//

import Foundation

class WebServices {

	public var session: URLSessionProtocol

	init(through session: URLSessionProtocol) {
		self.session = session
	}

//	init(session: URLSessionProtocol = URLSession.shared) {
//		self.session = session
//	}

	func testFunc() {
		// This is for testing git branch.
	}
	
	// Refactor this as a generic function.
	func getMusic(from urlStr: String, completion: @escaping (Music?, Error?) -> Void) {
		
		guard let url = URL(string: urlStr) else { fatalError() }
		
		let dataTask = session.myDataTask(with: url) { data, response, error in
			// Return for invalid status
			let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 200
			if statusCode != 200 {
				completion(nil, NSError(domain: "Invalid response", code: 30, userInfo: nil))
				return
			}
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
				completion(nil, NSError(domain: "Empty data", code: 20, userInfo: nil))
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

