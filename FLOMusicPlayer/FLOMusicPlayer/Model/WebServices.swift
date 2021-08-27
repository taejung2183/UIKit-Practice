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

	func downloadData(from urlStr: String, completion: @escaping (Data?, Error?) -> Void) {
		
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

			if let data = data {
				// data is not nil but empty.
				if data.isEmpty {
					completion(nil, NSError(domain: "Empty data", code: 20, userInfo: nil))
					return
				}
			} else {
				// data is nil.
				completion(nil, NSError(domain: "Nil data", code: 20, userInfo: nil))
				return
			}

			// Data is valid.
			completion(data, nil)
		}
		dataTask.resume()
	}
}
