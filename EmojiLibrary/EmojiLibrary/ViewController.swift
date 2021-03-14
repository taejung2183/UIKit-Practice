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

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let dataSource = DataSource()
    let delegate = EmojiCollectionViewDelegate(numberOfItemsPerRow: 6, interItemSpacing: 8)
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tell the collection view the the data source will be DataSource class instance.
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.allowsMultipleSelection = true
        
        // Tell the collection view that the data source will be ViewController.
        // collectionView.dataSource = self;
        
        // When you code your bar button not in storyboard, you get the toggle actoin between edit and done for free. Plus this sets view controller's isEditing property. we can use this property to adjust our segue action down below.
        navigationItem.leftBarButtonItem = editButtonItem
        if isEditing == true {
            // Change the rightBarButtonItem to the delete button.
        }
    }
    
    // When ViewCtronller goes into editing mode, cycle through any visible cells and set their editing states appropriately as well.
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        // Enable the delete button when editing.
        deleteButton.isEnabled = isEditing
        addButton.isEnabled = !isEditing
        
        // Iterate through each visible items on the screen.
        collectionView.indexPathsForVisibleItems.forEach {
            guard let emojiCell = collectionView.cellForItem(at: $0) as? EmojiCell else { return }
            // Set the cell's editing states properly.
            emojiCell.isEditing = editing
        }
        
        // If a user quit the editing mode, deselect the selected item so that the color can be changed to its original one.
        if isEditing == false {
            collectionView.indexPathsForSelectedItems?.compactMap({ $0 }).forEach({
                collectionView.deselectItem(at: $0, animated: true)
            })
        }
    }
    
    // Called before any segue is triggered.
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if isEditing && identifier == "showEmojiDetail" {
            return false
        }
        return true
    }
    
    // All segues initiated from this view controller will call this method.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showEmojiDetail",
              let emojiCell = sender as? EmojiCell,
              let emojiDetailController = segue.destination as? EmojiDetailController,
              // Use this indexPath to get the data out of the emoji type and assign it to the detail controller.
              let indexPath = collectionView.indexPath(for: emojiCell),
              let emoji = Emoji.shared.emoji(at: indexPath) else {
            fatalError()
        }
        
        emojiDetailController.emoji = emoji
    }
    
    @IBAction func addEmoji(_ sender: Any) {
        let (category, randomEmoji) = Emoji.randomEmoji()
        
        // If you have new data, you always need to first insert it into the data source.
        dataSource.addEmoji(randomEmoji, to: category)
        
        // Whenever your data source is changed, inform the collection view.
        // However, reloadData() reloads the entire collection view and asks it to set itself up all over again. This is an expensive operation.
        //collectionView.reloadData()
        
        // You're adding last item in the first section.
        // The cound value will always be one greater than the last index value.
        let emojiCount = collectionView.numberOfItems(inSection: 0)
        let insertedIndex = IndexPath(item: emojiCount, section: 0)
        
        // It's not asking for inserting, it asks for a place to insert.
        collectionView.insertItems(at: [insertedIndex])
    }
    
    @IBAction func deleteEmoji(_ sender: Any) {
        guard let selectedIndices = collectionView.indexPathsForSelectedItems else { return }
        // If you store each selected index's section in a set container, you will know which section should be reorganized. (Set stores unique values.)
        let sectionsToDelete = Set(selectedIndices.map({ $0.section }))
        sectionsToDelete.forEach({ section in
            let indexPathsForSection = selectedIndices.filter({ $0.section == section })
            // Sort it by item in descending order.
            // Delete the items from the biggest index because if you delete it from the smallest index every time you delete, all the indices behind will be changed.
            let sortedIndexPaths = indexPathsForSection.sorted(by: { $0.item > $1.item })
            
            dataSource.deleteEmoji(at: sortedIndexPaths)
            collectionView.deleteItems(at: sortedIndexPaths)
        })

        //dataSource.deleteEmoji(at: selectedIndices)
        //collectionView.deleteItems(at: selectedIndices)
        
        // You can make it work with this one line of code if you only have one section.
        //let indexPathsToDelete = selectedIndices.map({ $0.item }).reversed()
        
        // Instead, we need to reverse the order of the items within the particular section.
        
    }
}
// You ViewController class will be Data source for the Collection view.
/*
 extension ViewController: UICollectionViewDataSource {}
 */
