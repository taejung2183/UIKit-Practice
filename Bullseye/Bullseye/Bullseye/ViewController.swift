//
//  ViewController.swift
//  Bullseye
//
//  Created by atj on 2021/02/03.
//

import UIKit

class ViewController: UIViewController {

    var currentValue: Int = 0
    var targetValue: Int = 0
    var round = 0
    var totalScore = 0
    // When you want to connect your code with storyboard, write @IBOutlet or @IBAction.
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    
    // viewDidLoad is executed right after the app runs.
    override func viewDidLoad() {
        super.viewDidLoad()
        let roundedValue = slider.value.rounded()
        currentValue = Int(roundedValue)
        startNewGame()
        
        // Two way of initializing image.
        // 1. UIImage(named: "iamge-name")!
        //let thumbImageNormal = UIImage(named: "SliderThumb-Normal")!
        // 2. use Image Literal. (Write Image Literal and when the icon pops up, double click on it will show you images in your assets.xcassets)
        
        // For styling a slider you have to code.
        let thumbImageNormal = #imageLiteral(resourceName: "SliderThumb-Normal")
        slider.setThumbImage(thumbImageNormal, for: .normal)
        
        let thumbImageHighlighted = #imageLiteral(resourceName: "SliderThumb-Highlighted")
        slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        let trackLeftImage = #imageLiteral(resourceName: "SliderTrackLeft")
        let trackLeftResizable = trackLeftImage.resizableImage(withCapInsets: insets)
        slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
        
        let trackRightImage = #imageLiteral(resourceName: "SliderTrackRight")
        let trackRightResizable = trackRightImage.resizableImage(withCapInsets: insets)
        slider.setMaximumTrackImage(trackRightResizable, for: .normal)
    }

    @IBAction func showAlert() {
        let message = "The Value of the slider is now: \(currentValue)" +
        "\nThe target value is: \(targetValue)"
        // ViewController -> UIAlertController -> UIAlertAction
        let alert = UIAlertController(title: "You earned \(calculateScore()) points!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Awesome", style: .default, handler: {
            action in
            self.startNewRound()
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sliderMoved(_ slider: UISlider) {
        let roundedValue = slider.value.rounded()
        currentValue = Int(roundedValue)
    }
    
    @IBAction func startNewGame() {
        round = 0
        totalScore = 0
        startNewRound()
    }
    
    func startNewRound() {
        round += 1
        currentValue = 50
        slider.value = Float(currentValue)
        targetValue = Int.random(in: 1...100)
        updateLabels()
    }
    
    func updateLabels() {
        targetLabel.text = "\(targetValue)"
        roundLabel.text = "\(round)"
        totalScoreLabel.text = "\(totalScore)"
    }
    
    func calculateScore() -> Int {
        var score = 100 - abs(targetValue - currentValue)

        // Bonus points for 100, 99 score.
        if score == 100 {
            score += 100
        } else if score == 99 {
            score += 50
        } else {
            score += 0
        }
        
        totalScore += score
        return score
    }
}

  
