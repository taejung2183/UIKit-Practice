//
//  MusicData.swift
//  FLOMusicPlayer
//
//  Created by atj on 2021/07/31.
//

import Foundation

struct Data: Codable {
	let singer: String
	let album: String
	let title: String
	let duration: Int
	let image: String
	let file: String
	let lyrics: String
}

class MusicData {
	var data: Data
	
	init (data: Data) {
		self.data = data
	}
	
	func downloadData<T: URLSessionProtocol>(_ session: T, completionBlock: @escaping (Result<Data, Error>) -> Void) {
		if let url = URL(string: "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json") {
			let task = session.dataTask(with: url, completionHandler: {data, urlresponse, error in
				if let data = data {
					completionBlock(.success(data))
				}
			})
			task.resume()
		}
	}
}
