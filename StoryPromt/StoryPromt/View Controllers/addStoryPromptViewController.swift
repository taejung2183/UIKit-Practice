//
//  ViewController.swift
//  StoryPromt
//
//  Created by atj on 2021/02/11.
//

import UIKit
import PhotosUI // To use PHPicker

class addStoryPromptViewController: UIViewController {

    // 'weak' keyword prevents retain cycle.
    // When the instance has only weak reference, ARC doesn't count the reference so that the memory can be retrieved.
    @IBOutlet weak var nounTextField: UITextField!
    @IBOutlet weak var adjectiveTextField: UITextField!
    @IBOutlet weak var verbTextField: UITextField!
    @IBOutlet weak var numberSlider: UISlider!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var storyPromptImageView: UIImageView!
    
    let storyPrompt = StoryPromptEntry()
    
    @IBAction func changeNumber(_ sender: UISlider) {
        let sliderValue = Int(sender.value)
        numberLabel.text = "Number: \(sliderValue)"
        storyPrompt.number = sliderValue
    }
    
    @IBAction func changeStoryType(_ sender: UISegmentedControl) {
        if let genre = StoryPrompts.Genre(rawValue: sender.selectedSegmentIndex) {
            storyPrompt.genre = genre
        } else { // Default option.
            storyPrompt.genre = .scifi
        }
    }
    
    @IBAction func generateStoryPrompt(_ sender: UIButton) {
        updateStoryPrompt()
        if storyPrompt.isValid() == true {
            // Execute segue by code. In this way you can segue from ViewController to another ViewController at specific moment you want. Also you can pass any object with second argument and access it in the segue.
            performSegue(withIdentifier: "StoryPrompt", sender: nil)
        } else {
            let alert = UIAlertController(title: "Invalid Story Prompt", message: "Please fill out all of the fields", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { action in })
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberSlider.value = 7.5
        storyPrompt.number = Int(numberSlider.value)
        
        // User image interaction.
        storyPromptImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeImage))
        storyPromptImageView.addGestureRecognizer(gestureRecognizer)
        
        // 'self' for the first argument because that's the object we want to call.
        NotificationCenter.default.addObserver(self, selector: #selector(updateStoryPrompt), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        // This is how to set a delegate in code.
        //nounTextField.delegate = self
    }

    @objc func updateStoryPrompt() {
        storyPrompt.noun = nounTextField.text ?? ""
        storyPrompt.adjective = adjectiveTextField.text ?? ""
        storyPrompt.verb = verbTextField.text ?? ""
    }
    
    @objc func changeImage() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = self
        // Every ViewController contains 'present' method to modally present another ViewController.
        present(controller, animated: true)
    }
    
    // prepare method is called when segue to another ViewController. Right after entering prepare method, you need check if the segue get to the designated ViewController with identifier.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StoryPrompt" {
            guard let storyPromptViewController = segue.destination as? StoryPromptViewController else {
                return
            }
            storyPromptViewController.storyPrompt = storyPrompt
            storyPromptViewController.isNewStoryPrompt = true
        }
    }
}

extension addStoryPromptViewController: UITextFieldDelegate {

    // textField call this method whenever the user taps the return button.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard when the user taps the return btton.
        textField.resignFirstResponder()
        
        // Returning true indicates that we want the textField to use it's default behavior.
        return true
    }
}

// To fetch a user selected image.
extension addStoryPromptViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if results.isEmpty == false {
            let result = results.first!
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) {
                    [weak self] image, error in
                    guard let image = image as? UIImage else {
                        return
                    }
                    DispatchQueue.main.async {
                        self?.storyPromptImageView.image = image
                    }
                }
            }
        }
    }
}
