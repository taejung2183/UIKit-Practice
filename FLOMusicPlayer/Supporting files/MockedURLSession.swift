//
//  MockedURLSession.swift
//  FLOMusicPlayer
//
//  Created by atj on 2021/07/30.
//

import Foundation

protocol URLSessionProtocol {
	func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}
//extension URLSession: URLSessionProtocol {}

protocol URLSessionDataTaskProtocol {
	func resume()
}
//extension URLSessionDataTask: URLSessionDataTaskProtocol {}

class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
	private let closure: () -> Void
	init(closure: @escaping () -> Void) {
		self.closure = closure
	}
	func resume() {
		closure()
	}
}

class URLSessionMock: URLSessionProtocol {
	typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
	var data: Data?
	var error: Error?
	func dataTask(
		with url: URL,
		completionHandler: @escaping CompletionHandler
	) -> URLSessionDataTaskProtocol {
		let data = self.data
		let error = self.error
		return URLSessionDataTaskMock {
			completionHandler(data, nil, error)
		}
	}
}
