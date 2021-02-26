import UIKit

class LibraryHeaderView: UITableViewHeaderFooterView {
    
}

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

    // MARK:- Delegate
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Read Me!" : nil
    }
    
    // MARK:- Data Sorce
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : Library.books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == IndexPath(row: 0, section: 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewBookCell", for: indexPath)
            return cell
        }
        // We defined our BookCell class so we need to tell the table view to use our BookCell class as well as proto type cell.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(BookCell.self)", for: indexPath) as? BookCell else { fatalError("Could not create BookCell") }
        let book = Library.books[indexPath.row]
        // Make sure to set value for every view in that cell before you return it.
        cell.titleLabel?.text = book.title
        cell.authorLabel?.text = book.author
        cell.bookThumbnail?.image = book.image
        cell.bookThumbnail.layer.cornerRadius = 12
        
        return cell
    }
}

