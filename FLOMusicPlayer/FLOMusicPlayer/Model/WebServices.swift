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
			
			// Data is valid.
			completion(data, nil)
		}
		dataTask.resume()
	}
}
