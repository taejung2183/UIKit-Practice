/// These materials have been reviewed and are updated as of September, 2020
///
/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
///

import UIKit

class QueuedTutorialController: UIViewController {
    // Define arbitrary section type for data source. (Since we don't have a meaningful section type here. You can use another name, not necessarily "Section".)
    enum Section {
        case main
    }

    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    @IBOutlet var deleteButton: UIBarButtonItem!
    @IBOutlet var updateButton: UIBarButtonItem!
    @IBOutlet var applyUpdatesButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // You have to define section & item type but, you don't have a meaningful section type here. In this case you can create an arbitrary one.
    var dataSource: UICollectionViewDiffableDataSource<Section, Tutorial>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.title = "Queue"
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = nil
        
        
    }
}

// MARK: - Queue Events -

extension QueuedTutorialController {
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if isEditing {
            navigationItem.rightBarButtonItems = nil
            navigationItem.rightBarButtonItem = deleteButton
        } else {
            navigationItem.rightBarButtonItem = nil
            navigationItem.rightBarButtonItems = [self.applyUpdatesButton, self.updateButton]
        }
        
        collectionView.allowsMultipleSelection = true
        collectionView.indexPathsForVisibleItems.forEach { indexPath in
            guard let cell = collectionView.cellForItem(at: indexPath) as? QueueCell else { return }
            cell.isEditing = isEditing
            
            if !isEditing {
                cell.isSelected = false
            }
        }
    }
    
    @IBAction func deleteSelectedItems() {
        
    }
    
    @IBAction func triggerUpdates() {
        
    }
    
    @IBAction func applyUpdates() {
    }
}

// MARK: - Collection View -

// Display all the queued tutorials in a single section.
extension QueuedTutorialController {
    func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(148))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - Diffable Data Source -
extension QueuedTutorialController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Tutorial>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, tutorial: Tutorial) in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QueueCell.reuseIdentifier, for: indexPath) as? QueueCell else {
                return nil
            }
            
            cell.titleLabel.text = tutorial.title
            cell.thumbnailImageView.image = tutorial.image
            cell.thumbnailImageView.backgroundColor = tutorial.imageBackgroundColor
            cell.publishDateLabel.text = tutorial.formattedDate(using:  self.dateFormatter)
            
            return cell
        }
    }
    
    func configureSnapshot() {
        // Use arbitrary enum Section for section type just like you did for data source.
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tutorial>()
        snapshot.appendSections([.main])
        
        let queuedTutorials = DataSource.shared.tutorials.flatMap{ $0.queuedTutorials }
        snapshot.appendItems(queuedTutorials)
        
        dataSource.apply(snapshot, animatingDifferences:  true)
    }
}
