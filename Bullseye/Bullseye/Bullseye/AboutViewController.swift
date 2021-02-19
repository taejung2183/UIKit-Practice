//
//  AboutViewController.swift
//  Bullseye
//
//  Created by atj on 2021/02/09.
//

import UIKit
import WebKit

// When you create a new view controller, don't forget to connect this swift file to the appropriate view controller from the storyboard.
class AboutViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // When you use 'if' keyword here, the statement below only works if the exact file exist.
        if let htmlPath = Bundle.main.path(forResource: "BullsEye", ofType: "html") {
            let url = URL(fileURLWithPath: htmlPath)
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
}
