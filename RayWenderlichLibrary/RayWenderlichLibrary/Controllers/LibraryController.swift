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

final class LibraryController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // TutorialCollection for section type because it contains individual tutorial.
    private var dataSource: UICollectionViewDiffableDataSource<TutorialCollection, Tutorial>!
    // Property for a reference to the data from the plist.
    private let tutorialCollections = DataSource.shared.tutorials
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.title = "Library"
        
        collectionView.delegate = self
        // When you add supplementary view as a header in storyboard, the view is automatically register to the collection view. However, when it happens in code, you need to manually register for the collection view.
        collectionView.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)

        collectionView.collectionViewLayout = configureCollectionViewLayout()
        configureDataSource()
        configureSnapshot()
    }
    
}

// MARK: - Collection View -

// Add collection view layout code.
extension LibraryController {
    // This is one way you can customize your section based on runtime information.
    func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            // layoutEnvironment contains information about the layout environment at the time the collection view is set up. Properties like the trait collection and information about the layout container, such as content size and so on.
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            // Horizontal group.
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalHeight(0.3))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            // These properties below allows you to customize the scrolling behavior of groups inside a container.
            
            // Continuous orthogonal scrolling behavior means that when you scroll, the scroll view eventually decelerates and stops wherever.
            section.orthogonalScrollingBehavior = .continuous
            // This means when you scroll, it'll stop at the leading edge of the group's boundary.
            //section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            // This means when you scroll, it pages through one by one instead of scrolling all the way through.
            //section.orthogonalScrollingBehavior = .groupPaging
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            section.interGroupSpacing = 10
            
            // If you set the supplementary view to the data source, you also need to inform layout object that it has to create one.
            // To layout objects, it doesn't matter whether you're creating a header or a footer. It sees either view as a boundary supplementary item.
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}

// MARK: - Diffable Data Source
extension LibraryController {
    func configureDataSource() {
        typealias TutorialDataSource = UICollectionViewDiffableDataSource<TutorialCollection, Tutorial>
        // Provide which collection view to work with via first argument.
        // Also takes a closure for the second argument that defines how the collection view maps the data to each cell.
        dataSource = TutorialDataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, tutorial: Tutorial) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TutorialCell.reuseIdentifier, for: indexPath) as? TutorialCell else {
                return nil
            }
            
            cell.titleLabel.text = tutorial.title
            cell.thumbnailImageView.image = tutorial.image
            cell.thumbnailImageView.backgroundColor = tutorial.imageBackgroundColor
            
            return cell
        }
        
        // Add supplementary view. Register supplementary view to the collection view in setupView().
        // Capture self weakly to avoid reference cycles Since you're referencing self inside of a closure.
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, IndexPath: IndexPath) -> UICollectionReusableView? in
            // Avoid optional chaining with (let self = self)
            if let self = self, let titleSupplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier, for: IndexPath) as? TitleSupplementaryView {
                
                // To set the title supplementary view, you need to get the tutorial collection for the current section.
                // In order to do this, call the snapshot method on the current data source to get the current snapshot, query the list of section identifiers using the index path.
                let tutorialCollection = self.dataSource.snapshot().sectionIdentifiers[IndexPath.section]
                titleSupplementaryView.textLabel.text = tutorialCollection.title
                
                return titleSupplementaryView
            } else {
                return nil
            }
        }
    }
    
    func configureSnapshot() {
        var currentSnapshot = NSDiffableDataSourceSnapshot<TutorialCollection, Tutorial>()
        
        // Add each tutorial collection as a section.
        tutorialCollections.forEach { collection in
            currentSnapshot.appendSections([collection])
            currentSnapshot.appendItems(collection.tutorials)
        }
        
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegate -

// When a user selects an item, segue to the tutorial detail view.
extension LibraryController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Find user selected item.
        if let tutorial = dataSource.itemIdentifier(for: indexPath),
           let tutorialDetailController = storyboard?.instantiateViewController(identifier:  TutorialDetailViewController.identifier, creator: { coder in
            return TutorialDetailViewController(coder: coder, tutorial: tutorial)
           }) {
            // Present the tutorial detail controller on screen.
            show(tutorialDetailController, sender: nil)
        }
    }
}
