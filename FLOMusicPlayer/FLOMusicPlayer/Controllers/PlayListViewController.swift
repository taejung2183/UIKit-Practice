//
//  ViewController.swift
//  FLOMusicPlayer
//
//  Created by atj on 2021/07/05.
//

import UIKit

class PlayListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	let tableView = UITableView()
	
	var music: Music?
	var albumImage: UIImage?

	override func viewDidLoad() {
		super.viewDidLoad()
		
		setUpTableView()

		getMusicFromURL()
		
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	func getMusicFromURL() {
		let session = URLSession(configuration: .default)
		let service = WebServices(through: session)
		let url = "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json"

		service.downloadData(from: url) { (music: Music?, error) in
			if error == nil { self.music = music }
		}
		
		// Get image through url that you've got it form music data.
//		if let music = music {
//			let url = music.image
//
//			service.downloadData(from: url) { (image: UIImage?, error) in
//
//			}
//		}
	}

	func setUpTableView() {
		view.addSubview(tableView)
		tableView.register(MusicCell.self, forCellReuseIdentifier: MusicCell.identifier)
		tableView.allowsSelection = true
		tableView.isUserInteractionEnabled = true
		
		// Set the table view in full screen.
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
		tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		tableView.frame = view.bounds
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: MusicCell.identifier, for: indexPath) as? MusicCell else { return UITableViewCell() }
		
		guard let data = music else {
			print("Empty cell")
			cell.configureCell(imageName: "placeholder", title: "nil", artist: "nil")
			return cell
		}
		
		cell.configureCell(imageName: "placeholder", title: data.title, artist: data.singer)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// Unhighlight the selected cell.
		tableView.deselectRow(at: indexPath, animated: true)
		print("cell tapped")
	}
}

