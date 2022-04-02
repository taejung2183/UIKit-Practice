//
//  ViewController.swift
//  FLOMusicPlayer
//
//  Created by atj on 2021/07/05.
//

import UIKit

class PlayListViewController: UIViewController {
	
	let tableView = UITableView()
	var dataSource: PlayListDataSource? = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setUpTableView()
		view.addSubview(tableView)
		
		self.getMusic(from: "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json")
	}
	
	func setUpTableView() {
		// tableView configuration.
		tableView.allowsSelection = true
		tableView.isUserInteractionEnabled = true
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
		// Let the table view covers the entire super view.
		tableView.frame = view.bounds
		tableView.rowHeight = 60
		
		tableView.dataSource = dataSource
		tableView.register(MusicCell.self, forCellReuseIdentifier: MusicCell.identifier)
	}
	
	func getMusic(from url: String) {
		let webService = WebServices(through: URLSession(configuration: .default))
		
		// Get music data.
		webService.downloadData(from: url) { [weak self] data, error in
			
			guard error == nil, let musicData = data else { return }

			do {
				let music = try JSONDecoder().decode(Music.self, from: musicData)
				self?.dataSource?.musicArray?.append(music)
			
				// Get image data.
				let imageUrl = music.image
				webService.downloadData(from: imageUrl) { data, error in
					
					guard error == nil, let imageData = data else { return }
					self?.dataSource?.albumImageArray?.append(UIImage(data: imageData)!)
					
					// isLoaded indicates the image download is done.
					self?.dataSource?.isLoaded = true
					
					DispatchQueue.main.async {
						self?.tableView.reloadData()
					}
				}
				
			} catch { fatalError("ERROR INFO: \(error)") }
		}
		
	}
}
