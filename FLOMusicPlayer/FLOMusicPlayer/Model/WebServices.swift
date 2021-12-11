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
			
			// Check invalid response.
			guard let httpResponse = response as? HTTPURLResponse,
				  (200...299).contains(httpResponse.statusCode) else {
				print("Invalid response.")
				completion(nil, NSError(domain: "Invalid response", code: 30, userInfo: nil))
				return
			}
			
			// error should be nil.
			guard error == nil else {
				print("Error.")
				completion(nil, error)
				return
			}

			if let data = data {
				// Return error for empty data.
				if data.isEmpty {
					print("Empty data.")
					completion(nil, NSError(domain: "Empty data", code: 20, userInfo: nil))
					return
				}
				// Return valid data.
				else {
					print("Valid request.")
					completion(data, nil) }
			}
			else {
				// Return error for nil data.
				print("Nil return.")
				completion(nil, NSError(domain: "Nil data", code: 10, userInfo: nil))
				return
			}
		}
		
		dataTask.resume()
	}
}

