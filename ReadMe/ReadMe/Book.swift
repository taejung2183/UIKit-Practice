import UIKit

struct Book {
    let title: String
    let author: String
    
    var image: UIImage {
        // If there's an image for the book then load, or set it with a symbol by default.
        Library.loadImage(forBook: self) ?? LibrarySymbol.letterSquare(letter: title.first).image
    }
}
