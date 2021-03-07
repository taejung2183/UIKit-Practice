import UIKit

// By conforming Hashable, allows diffable data source to compare to see if anything needs to change.
// Hashable is automatically synthesized if you use struct.
struct Book: Hashable {
    let title: String
    let author: String
    var review: String?
    var readMe: Bool
    
    // The library is already loading up the images for us.
    var image: UIImage?/* {
        // If there's an image for the book then load, or set it with a symbol by default.
        Library.loadImage(forBook: self) ?? LibrarySymbol.letterSquare(letter: title.first).image
    }*/
    static let mockBook = Book(title: "", author: "", readMe: true)
}

// This will allow library save books to a json file behind the scenes.
extension Book: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case author
        case review
        case readMe
    }
}
