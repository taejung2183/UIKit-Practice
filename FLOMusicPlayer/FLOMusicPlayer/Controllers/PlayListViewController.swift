//
//  ViewController.swift
//  FLOMusicPlayer
//
//  Created by atj on 2021/07/05.
//

import UIKit

class PlayListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	let tableView = UITableView()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(tableView)
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		tableView.delegate = self
		tableView.dataSource = self
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		tableView.frame = view.bounds
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		10
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		
		cell.textLabel?.text = "Cell \(indexPath.row + 1)"
		return cell
	}
}

