//
//  ViewController.swift
//  FLOMusicPlayer
//
//  Created by atj on 2021/07/05.
//

import UIKit

class PlayListViewController: UIViewController {
	
	let tableView = UITableView()
	// PlayListViewController is root view controller.
	// Where do you feed dataSource before the app runs?
	var dataSource: PlayListDataSource!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(tableView)
		setUpTableView()
	}
	
	func setUpTableView() {
		// tableView configuration.
		tableView.allowsSelection = true
		tableView.isUserInteractionEnabled = true
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
		// Make table view covers the entire super view.
		tableView.frame = view.bounds
		
		tableView.dataSource = dataSource
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MusicCell")
	}
}

//class PlayListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//	let tableView = UITableView()
//
//	var music: [Music]? = []
//	var albumImage: [UIImage]? = []
//
//	override func viewDidLoad() {
//		super.viewDidLoad()
//
//		setUpTableView()
//
//		getMusicFromURL()
//
//		tableView.delegate = self
//		tableView.dataSource = self
//	}

	/*
	
	I am downloading all the music data from the url
	right after the app runs. (Precisely, when the
	root view is initiated.)
	
	If it was an actual streaming app, (of course you
	should have all the data if it's something like a
	MP3.) retieving the particular data of the music
	right before you actually stream the music will be
	more efficient.


	https://joesusnick.medium.com/tdd-tableviews-less-boring-than-you-think-fe080fcc41d1
	https://developer.apple.com/videos/play/wwdc2017/414/
	
	Check out the references above if you want to
	implement URLOpener protocol to open url after you
	touch the cell.

	*/

//	func getMusicFromURL() {
//		let session = URLSession(configuration: .default)
//		let service = WebServices(through: session)
//		let url = "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json"
//
//		// Get music data from url
//		service.downloadData(from: url) { data, error in
//
//			guard error == nil, let musicData = data else { return }
//
//			// Get music data
//			do {
//				let music = try JSONDecoder().decode(Music.self, from: musicData)
//
//				if self.music?.append(music) == nil {
//					self.music = [music]
//				}
//
//			} catch {
//				fatalError("ERROR INFO: \(error)")
//			}
//
//
//			// Get image data from url in music data
//			guard let imageUrl = self.music?.first?.image else { return }
//
//			service.downloadData(from: imageUrl) { data, error in
//
//				guard error == nil, let data = data else { return }
//
//				if let image = UIImage(data: data) {
//					if self.albumImage?.append(image) == nil {
//						self.albumImage = [image]
//					}
//				}
//			}
//		}
//
//		// Read local JSON file
////		if let jsonUrl = Bundle.main.url(forResource: "PlayList", withExtension: "json") {
////
////			do {
////				let data = try Data(contentsOf: jsonUrl)
////				let decodedData = try JSONDecoder().decode([Music].self, from: data)
////
////				for d in decodedData {
////					self.music?.append(d)
////				}
////
//////				for m in self.music! {
//////					print(m.singer)
//////				}
////			} catch {
////				print(error)
////			}
////		}
//	}
//
//	func setUpTableView() {
//		view.addSubview(tableView)
//		tableView.register(MusicCell.self, forCellReuseIdentifier: MusicCell.identifier)
//		tableView.allowsSelection = true
//		tableView.isUserInteractionEnabled = true
//
//		// Set the table view in full screen.
//		tableView.translatesAutoresizingMaskIntoConstraints = false
//		tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//		tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//		tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
//		tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
//	}
//
//	override func viewDidLayoutSubviews() {
//		super.viewDidLayoutSubviews()
//		tableView.frame = view.bounds
//	}
//
//	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return music?.count ?? 0
//	}
//
//	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//		guard let cell = tableView.dequeueReusableCell(withIdentifier: MusicCell.identifier, for: indexPath) as? MusicCell else { return UITableViewCell() }
//
//		if let music = music?[indexPath.row], let image = albumImage?[indexPath.row] {
//			cell.configureCell(image: image, title: music.title, artist: music.singer)
//		} else {
//			print("Empty cell")
//			cell.configureCell(image: UIImage(named: "placeholder")!, title: "nil", artist: "nil")
//		}
//
//		return cell
//	}
//
//	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		// Unhighlight the selected cell.
//		tableView.deselectRow(at: indexPath, animated: true)
//		print("cell tapped")
//	}
//}
//
