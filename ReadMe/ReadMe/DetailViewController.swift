import UIKit

class DetailViewController: UITableViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var reviewTextView: UITextView!
    
    var book: Book
    
    @IBOutlet var readMeButton: UIButton!
    
    @IBAction func toggleReadMe() {
        book.readMe.toggle()
        let image = book.readMe ? LibrarySymbol.bookmarkFill.image : LibrarySymbol.bookmark.image
        readMeButton.setImage(image, for: .normal)
    }
    
    @IBAction func saveChange() {
        Library.update(book: book)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = book.image ?? LibrarySymbol.letterSquare(letter: book.title.first).image
        imageView.layer.cornerRadius = 16
        titleLabel.text = book.title
        authorLabel.text = book.author
        
        if let review = book.review {
            reviewTextView.text = review
        }
        
        let image = book.readMe ? LibrarySymbol.bookmarkFill.image : LibrarySymbol.bookmark.image
        readMeButton.setImage(image, for: .normal)
        
        reviewTextView.addDoneButton()
    }
    
    // Initializing storyboard view controllers behind the scene.
    // When view controller loads from the interface builder, it uses an init coder initializer like this.
    required init?(coder: NSCoder) {
        // In order to make our own initializer, this init should do nothing.
        // We don't want this init to be called bc the only time a Detail View Controller will load is when we call the next initializer below.
        fatalError("This should never be called!")
    }
    
    // We can take whatever other parameters we want to.
    init?(coder: NSCoder, book: Book) {
        self.book = book
        super.init(coder: coder)
    }
}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        imageView.image = selectedImage
        //Library.saveImage(selectedImage, forBook: book)
        book.image = selectedImage
        dismiss(animated: true)
    }
}

extension DetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        book.review = textView.text
        textView.resignFirstResponder()
    }
}

extension UITextView {
    func addDoneButton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.resignFirstResponder))
        toolbar.items = [flexSpace, doneButton]
        self.inputAccessoryView = toolbar
    }
}
