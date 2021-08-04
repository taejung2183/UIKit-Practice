//
//  MockedURLSession.swift
//  FLOMusicPlayer
//
//  Created by atj on 2021/07/30.
//

import Foundation

protocol URLSessionProtocol {
	func dataTask(
		with url: URL,
		completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
	) -> URLSessionDataTaskProtocol
}
//extension URLSession: URLSessionProtocol {}

protocol URLSessionDataTaskProtocol {
	func resume()
}

class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
	private let data: Data?
	private let urlResponse: URLResponse?
	private let error: Error?
	var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
	
	init(data: Data?, urlResponse: URLResponse?, error: Error?) {
		self.data = data
		self.urlResponse = urlResponse
		self.error = error
	}
	
	func resume() {
		DispatchQueue.main.async {
			self.completionHandler?(self.data, self.urlResponse, self.error)
		}
	}
}

class URLSessionMock: URLSessionProtocol {
	var cachedUrl: URL?
	private let mockedDataTask: URLSessionDataTaskMock
	
	init(data: Data?, urlResponse: URLResponse?, error: Error?) {
		mockedDataTask = URLSessionDataTaskMock(data: data, urlResponse: urlResponse, error: error)
	}
	
	func dataTask(
		with url: URL,
		completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
	) -> URLSessionDataTaskProtocol {
		self.cachedUrl = url
		mockedDataTask.completionHandler = completionHandler

		return mockedDataTask
	}
}
