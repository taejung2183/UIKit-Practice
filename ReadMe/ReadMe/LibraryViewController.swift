import UIKit

class LibraryHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "\(LibraryHeaderView.self)"
    @IBOutlet var titleLabel: UILabel!
}

enum SortStyle {
    case title
    case author
    case readMe
}

enum Section: String, CaseIterable {
    case addNew
    case readMe = "Read Me!"
    case finished = "Finished!"
}

class LibraryViewController: UITableViewController {
    
    //var dataSource: UITableViewDiffableDataSource<Section, Book>!
    var dataSource: LibraryDataSource!
    
    @IBOutlet var sortButtons: [UIBarButtonItem]!
    
    @IBAction func sortByTitle(_ sender: UIBarButtonItem) {
        dataSource.update(sortStyle: .title)
        updateTintColors(tappedButton: sender)
    }
    
    @IBAction func sortByAuthor(_ sender: UIBarButtonItem) {
        dataSource.update(sortStyle: .author)
        updateTintColors(tappedButton: sender)
    }
    
    @IBAction func sortByReadMe(_ sender: UIBarButtonItem) {
        dataSource.update(sortStyle: .readMe)
        updateTintColors(tappedButton: sender)
    }
    
    func updateTintColors(tappedButton: UIBarButtonItem) {
        sortButtons.forEach { button in
            button.tintColor = button == tappedButton ? button.customView?.tintColor : .secondaryLabel
        }
    }
    
    @IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow,
              let book = dataSource.itemIdentifier(for: indexPath)
        else { fatalError("Nothing selected!") }
        //let book = Library.books[indexPath.row]
        return DetailViewController(coder: coder, book: book)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Insert edit bar button item. (It works as an actual edit button systematically.
        navigationItem.rightBarButtonItem = editButtonItem
        
        tableView.register(UINib(nibName: "\(LibraryHeaderView.self)", bundle: nil), forHeaderFooterViewReuseIdentifier: LibraryHeaderView.reuseIdentifier)
        
        configureDataSource()
        dataSource.update(sortStyle: .readMe)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //tableView.reloadData()
        // Update the data source when we come back from the detail screen or new book screen.
        dataSource.update(sortStyle: dataSource.currentSortStyle)
    }

    // MARK:- Delegate
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Read Me!" : nil
        
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        
        // Deqeue reusable Header just as we did for the reusable cell.
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: LibraryHeaderView.reuseIdentifier) as? LibraryHeaderView else { return nil }
        
        // Set the title based on the value of each case.
        headerView.titleLabel.text = Section.allCases[section].rawValue
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section != 0 ? 60 : 0
    }
    
    // MARK:- Data Source
    
//    --------(UITableViewDiffableDatsSource)--------
    
    func configureDataSource() {
        dataSource = LibraryDataSource(tableView: tableView) {
            tableView, indexPath, book -> UITableViewCell? in
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
            cell.bookThumbnail?.image = book.image ?? LibrarySymbol.letterSquare(letter: book.title.first).image
            cell.bookThumbnail.layer.cornerRadius = 12
            
            if let review = book.review {
                cell.reviewLabel.text = review
                cell.reviewLabel.isHidden = false
            }
            cell.readMeBookmark.isHidden = !book.readMe
            
            return cell
        }
    }
    
    
    
//    --------(UITableViewDataSource)--------
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        2
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return section == 0 ? 1 : Library.books.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath == IndexPath(row: 0, section: 0) {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "NewBookCell", for: indexPath)
//            return cell
//        }
//        // We defined our BookCell class so we need to tell the table view to use our BookCell class as well as proto type cell.
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(BookCell.self)", for: indexPath) as? BookCell else { fatalError("Could not create BookCell") }
//        let book = Library.books[indexPath.row]
//        // Make sure to set value for every view in that cell before you return it.
//        cell.titleLabel?.text = book.title
//        cell.authorLabel?.text = book.author
//        cell.bookThumbnail?.image = book.image
//        cell.bookThumbnail.layer.cornerRadius = 12
//
//        return cell
//    }
}

class LibraryDataSource: UITableViewDiffableDataSource<Section, Book> {
    var currentSortStyle: SortStyle = .title
    
    // Make a snapshot of the data we want to display.
    func update(sortStyle: SortStyle, animatingDifferences: Bool = true) {
        currentSortStyle = sortStyle
        
        var newSnapshot = NSDiffableDataSourceSnapshot<Section, Book>()
        newSnapshot.appendSections(Section.allCases)
        //newSnapshot.appendItems(Library.books, toSection: .readMe)
        // We can iterate through all the items to put it in the correct section according to its readMe, but we can also do this through a dictionary container.
        
        // Dictionary with Bool typed key. The value for the true key is the array of Book that need to be read, for the false key is all of the finished books.
        let booksByReadMe: [Bool: [Book]] = Dictionary(grouping: Library.books, by: \.readMe)
        for (readMe, books) in booksByReadMe {
            var sortedBooks: [Book]
            switch sortStyle {
            case .title:
                sortedBooks = books.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
            case .author:
                sortedBooks = books.sorted { $0.author.localizedCaseInsensitiveCompare($1.author) == .orderedAscending }
            case .readMe:
               sortedBooks = books
            }
            
            newSnapshot.appendItems(sortedBooks, toSection: readMe ? .readMe: .finished)
        }
        newSnapshot.appendItems([Book.mockBook], toSection: .addNew)
        apply(newSnapshot, animatingDifferences: animatingDifferences)
    }
    
    // MARK: Editing cells
    
    // Specify if the user should be able to delete something at a given indexPath.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // addNew section cannot be edited. Otherwise editing is fine.
        indexPath.section == snapshot().indexOfSection(.addNew) ? false : true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Each row in table view has an editingStyle property. It's an enum with three cases. (None, Insert, Delete) Default option for editing style is Delete.
        if editingStyle == .delete {
            guard let book = self.itemIdentifier(for: indexPath) else { return }
            Library.delete(book: book)
            update(sortStyle: currentSortStyle)
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // If the cell is not in the readMe section, don't let them move.
        if indexPath.section != snapshot().indexOfSection(.readMe) && currentSortStyle == .readMe {
            return false
        } else {
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // sourceIndexPath: Where the cell is coming from.
        // destinationIndexPath: Where the cell will be put.
        guard
            sourceIndexPath != destinationIndexPath,
            sourceIndexPath.section == destinationIndexPath.section,
            let bookToMove = itemIdentifier(for: sourceIndexPath),
            let bookAtDestination = itemIdentifier(for: destinationIndexPath)
        else {
            // This will ensure nothing actually changes.
            apply(snapshot(), animatingDifferences: false)
            return
        }
        
        Library.reorderBooks(bookToMove: bookToMove, bookAtDestination: bookAtDestination)
        // We don't want to animate changes to this update.
        update(sortStyle: currentSortStyle, animatingDifferences: false)
    }
}
