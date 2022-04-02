//
//  MusicCell.swift
//  FLOMusicPlayer
//
//  Created by atj on 2021/08/10.
//

import UIKit

class MusicCell: UITableViewCell{
	static let identifier = "MusicCell"
	
	// UI elements need to be private?
	
	let albumImage: UIImageView = {
		let placeHolderImage = UIImage(named: "placeholder")
		let imgView = UIImageView(image: placeHolderImage)
		
		imgView.contentMode = .scaleAspectFit
		imgView.clipsToBounds = true
		return imgView
	}()
	
	let titleLabel: UILabel = {
		let lbl = UILabel()
		lbl.textColor = .black
		lbl.font = UIFont.systemFont(ofSize: 18, weight: .bold)
		lbl.textAlignment = .left
		lbl.text = "Title"
		lbl.sizeToFit()
		return lbl
	}()
	
	let artistLabel: UILabel = {
		let lbl = UILabel()
		lbl.textColor = .black
		lbl.font = UIFont.systemFont(ofSize: 12)
		lbl.textAlignment = .left
		lbl.text = "Artist"
		return lbl
	}()
	
	let moreButton: UIButton = {
		let btn = UIButton()
		btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
		btn.tintColor = .black
		return btn
	}()
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.addSubview(albumImage)
		contentView.addSubview(titleLabel)
		contentView.addSubview(artistLabel)
		contentView.addSubview(moreButton)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		// Album image view constraints.
		albumImage.translatesAutoresizingMaskIntoConstraints = false
		let albumImageConstraints = [
			albumImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
			albumImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			albumImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10),
			albumImage.widthAnchor.constraint(equalTo: contentView.heightAnchor)
		]
		
		// Title label constraints.
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		let titleLabelConstraints = [
			titleLabel.leadingAnchor.constraint(equalTo: albumImage.trailingAnchor, constant: 10),
			titleLabel.topAnchor.constraint(equalTo: albumImage.topAnchor),
			titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -120)
		]
		
		// Artist label constraints.
		artistLabel.translatesAutoresizingMaskIntoConstraints = false
		let artistLabelConstraints = [
			artistLabel.leadingAnchor.constraint(equalTo: albumImage.trailingAnchor, constant: 10),
			artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
			artistLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -120)
		]
		
		// More button constraints.
		moreButton.translatesAutoresizingMaskIntoConstraints = false
		let moreButtonConstraints = [
			moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
			moreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		]
		
		NSLayoutConstraint.activate(albumImageConstraints)
		NSLayoutConstraint.activate(titleLabelConstraints)
		NSLayoutConstraint.activate(artistLabelConstraints)
		NSLayoutConstraint.activate(moreButtonConstraints)
	}
}
