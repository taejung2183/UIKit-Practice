//
//  PlayListDataSource.swift
//  FLOMusicPlayer
//
//  Created by atj on 2021/09/29.
//

import UIKit

class PlayListDataSource: NSObject, UITableViewDataSource {
	
	private var music: [Music]
	static let identifier = "MusicCell"

	init(music: [Music]) {
		self.music = music
		super.init()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		music.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		guard let cell = tableView.dequeueReusableCell(withIdentifier: MusicCell.identifier, for: indexPath) as? MusicCell
//		else {
//			let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath)
//			cell.textLabel?.text = music[indexPath.row].singer
//			return cell
//		}
//		return cell
		let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath)
		cell.textLabel?.text = music[indexPath.row].singer
		return cell
	}
}
