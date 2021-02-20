//
//  ViewController.swift
//  ReadMe
//
//  Created by atj on 2021/02/19.
//

import UIKit

class LibraryViewController: UITableViewController {
    @IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("Nothing selected!")
        }
        let book = Library.books[indexPath.row]
        return DetailViewController(coder: coder, book: book)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK:- DataSorce
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Library.books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // We defined our BookCell class so we need to tell the table view to use our BookCell class as well as proto type cell.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(BookCell.self)", for: indexPath) as? BookCell else { fatalError("Could not create BookCell") }
        //let book = Book(title: "Title \(indexPath)", author: "Author \(indexPath)", image: UIImage(systemName: "\(indexPath.row).square.fill")!)
        let book = Library.books[indexPath.row]
        // Make sure to set value for every view in that cell before you return it.
        cell.titleLabel?.text = book.title
        cell.authorLabel?.text = book.author
        cell.bookThumbnail?.image = book.image
        cell.bookThumbnail.layer.cornerRadius = 12
        
        return cell
    }
}

