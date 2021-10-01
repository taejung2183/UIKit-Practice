//
//  MusicCell.swift
//  FLOMusicPlayer
//
//  Created by atj on 2021/08/10.
//

import UIKit

//class MusicCell: UITableViewCell {
//	static let identifier = "MusicCell"
//
//	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//		super.init(style: style, reuseIdentifier: reuseIdentifier)
//		contentView.addSubview(albumImage)
//		contentView.addSubview(titleLabel)
//		contentView.addSubview(artistLabel)
//		contentView.addSubview(moreButton)
//	}
//
//	required init?(coder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
//	}
//
//	public func configureCell(image: UIImage, title: String, artist: String) {
//		albumImage.image = image
//		titleLabel.text = title
//		artistLabel.text = artist
//	}
//
//	override func prepareForReuse() {
//		super.prepareForReuse()
//		albumImage.image = nil
//		titleLabel.text = nil
//		artistLabel.text = nil
//	}
//
//	override func layoutSubviews() {
//		super.layoutSubviews()
//
//		// Constraints for album image.
//		albumImage.translatesAutoresizingMaskIntoConstraints = false
//		albumImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
//		albumImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
//		albumImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10).isActive = true
//		albumImage.widthAnchor.constraint(equalTo: albumImage.heightAnchor).isActive = true
//
//		// Constraints for title label.
//		titleLabel.translatesAutoresizingMaskIntoConstraints = false
//		titleLabel.leadingAnchor.constraint(equalTo: albumImage.trailingAnchor, constant: 10).isActive = true
//		titleLabel.topAnchor.constraint(equalTo: albumImage.topAnchor).isActive = true
//		titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -120).isActive = true
//
//		// Constraints for artist lable.
//		artistLabel.translatesAutoresizingMaskIntoConstraints = false
//		artistLabel.leadingAnchor.constraint(equalTo: albumImage.trailingAnchor, constant: 10).isActive = true
//		artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2).isActive = true
//		artistLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -120).isActive = true
//
//		// Constraints for more button.
//		moreButton.translatesAutoresizingMaskIntoConstraints = false
//		moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
//		moreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
//	}
//
//	private let albumImage: UIImageView = {
//		let placeholder = UIImage(named: "placeholder")
//		let imgView = UIImageView(image: placeholder)
//		imgView.contentMode = .scaleAspectFit
//		imgView.clipsToBounds = true
//		return imgView
//	}()
//
//	private let titleLabel: UILabel = {
//		let lbl = UILabel()
//		lbl.textColor = .black
//		lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
//		lbl.textAlignment = .left
//		lbl.sizeToFit()
//		lbl.text = "Title here"
//		return lbl
//	}()
//
//	private let artistLabel: UILabel = {
//		let lbl = UILabel()
//		lbl.textColor = .black
//		lbl.font = UIFont.systemFont(ofSize: 10)
//		lbl.textAlignment = .left
//		lbl.text = "Artist here"
//		return lbl
//	}()
//
//	private let moreButton: UIButton = {
//		let btn = UIButton()
//		btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
//		btn.tintColor = .black
//		return btn
//	}()
//
//}
