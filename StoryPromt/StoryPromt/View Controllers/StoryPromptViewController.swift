//
//  StoryPromptViewController.swift
//  StoryPromt
//
//  Created by atj on 2021/02/11.
//

import UIKit

class StoryPromptViewController: UIViewController {

    @IBOutlet weak var storyPromptTextView: UITextView!

    var storyPrompt: StoryPromptEntry?
    var isNewStoryPrompt = false

    override func viewDidLoad() {
        super.viewDidLoad()
       
        storyPromptTextView.text = storyPrompt?.description
        
        if isNewStoryPrompt == true {
            let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveStoryPrompt))
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelStoryPrompt))
            navigationItem.rightBarButtonItem = saveButton
            navigationItem.leftBarButtonItem = cancelButton
        }
    }
    
    // Hiding NavigationBar.
    /*
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    */
    
    @objc func cancelStoryPrompt() {
        performSegue(withIdentifier: "CancelStoryPrompt", sender: nil)
    }
    
    @objc func saveStoryPrompt() {
        NotificationCenter.default.post(name: .StoryPromptSaved, object: storyPrompt)
        performSegue(withIdentifier: "SaveStoryPrompt", sender: nil)
    }
}

// Define Notification.Name extension and post it where you want to be notified.
extension Notification.Name {
    static let StoryPromptSaved = Notification.Name("StoryPromptSave")
}
