//
//  PlayListDataSource.swift
//  FLOMusicPlayer
//
//  Created by atj on 2021/09/29.
//

import UIKit

class PlayListDataSource: NSObject, UITableViewDataSource {

	private var _musicArray: [Music]? = nil
	public var musicArray: [Music]? {
		get { return _musicArray }
		set { _musicArray = newValue }
	}
	
	private var _albumImageArray: [UIImage]? = nil
	public var albumImageArray: [UIImage]? {
		get { return _albumImageArray }
		set { _albumImageArray = newValue }
	}
	
	private var _isLoaded = false
	public var isLoaded: Bool {
		get { return _isLoaded }
		set { _isLoaded = newValue }
	}
	
	init(musicArray: [Music], albumImageArray: [UIImage]) {
		super.init()
		self._musicArray = musicArray
		self._albumImageArray = albumImageArray
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		_musicArray?.count ?? 0
		_albumImageArray?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: MusicCell.identifier, for: indexPath) as? MusicCell, let musicArr = _musicArray, let imageArr = _albumImageArray else { fatalError() }
		var image: UIImage
		
		if imageArr.isEmpty {
			// Check empty for the test.
			image = UIImage(named: "placeholder")!
		}
		else if indexPath.row == 0 || indexPath.row == 1 {
			// First two images are in the assets.
			image = imageArr[indexPath.row]
		}
		else {
			// Access only when the download is done.
			if (_isLoaded) {
				image = imageArr[indexPath.row]
				
			} else {
				image = UIImage(named: "placeholder")!
			}
		}
		
		cell.albumImage.image = image
		cell.titleLabel.text = musicArr[indexPath.row].title
		cell.artistLabel.text = musicArr[indexPath.row].singer
		
		return cell
	}
}
