//
//  DataSource.swift
//  EmojiLibrary
//
//  Created by atj on 2021/03/13.
//

import UIKit

// Inherit NSObject because UICollectionView expects its data source to be an Objective-C class.
class DataSource: NSObject, UICollectionViewDataSource {
    let emoji = Emoji.shared
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        emoji.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let category = emoji.sections[section]
        
        // The value for emoji is optional array of string. (emoji are string literals.)
        // Dictionary subbscripting returns optional values in case the key doesn't exist.
        let emoji = self.emoji.data[category]?.count ?? 0
        
        return emoji
    }
    
    // Use the informations of collectionView and indexPath of cell to create a cell and return it for the collection view to use.
    //
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let emojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.reuseIdentifier, for: indexPath) as? EmojiCell else {
            fatalError()
        }
        
        // Data source must already contain the emoji before you call the insert method. This order is extremely important.
        let category = emoji.sections[indexPath.section]
        let emoji = self.emoji.data[category]?[indexPath.item] ?? ""
        
        emojiCell.emojiLabel.text = emoji
        
        return emojiCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let emojiHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EmojiHeaderView.reuseIdentifier, for: indexPath) as? EmojiHeaderView else { fatalError() }
        
        let category = emoji.sections[indexPath.section]
        emojiHeaderView.textLabel.text = category.rawValue
        
        return emojiHeaderView
    }
}

extension DataSource {
    func addEmoji(_ emoji: String, to category: Emoji.Category) {
        guard var emojiData = self.emoji.data[category] else { return }
        emojiData.append(emoji)
        self.emoji.data.updateValue(emojiData, forKey: category)
    }
    
    // This can delete just one emoji at a time.
    func deleteEmoji(at indexPath: IndexPath) {
        let category = emoji.sections[indexPath.section]
        guard var emojiData = emoji.data[category] else { return }
        emojiData.remove(at: indexPath.item)
        
        // Swift data structures are value types. We need to update the dictionary with the new array copy.
        emoji.data.updateValue(emojiData, forKey: category)
    }
    
    // Deleting several emoji at a time.
    func deleteEmoji(at indexPaths: [IndexPath]) {
        for path in indexPaths {
            deleteEmoji(at: path)
        }
    }
}
