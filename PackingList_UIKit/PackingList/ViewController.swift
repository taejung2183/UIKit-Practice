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

import UIKit

final class ViewController: UIViewController {
    //MARK:- IB Outlets
    
    @IBOutlet private var tableView: TableView! {
        didSet { tableView.handleSelection = showItem }
    }
    
    @IBOutlet private var menuButton: UIButton!
    @IBOutlet private var titleLabel: UILabel!
    
    @IBOutlet private var menuHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var menuButtonTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet private var titleCenterYClosedConstraint: NSLayoutConstraint!
    // Uncheck the installed in the attribute inspector so that this constraint is not already activated when the app is started.
    @IBOutlet private var titleCenterYOpenConstraint: NSLayoutConstraint!

    //MARK:- Variables
    
    private var slider: HorizontalItemSlider!
    private var menuIsOpen = false
}

//MARK:- UIViewController
extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider = HorizontalItemSlider(in: view) { [unowned self] item in
            self.tableView.addItem(item)
            self.transitionCloseMenu()
        }
        titleLabel.superview!.addSubview(slider)
    }
}

//MARK:- private
private extension ViewController {
    @IBAction func toggleMenu() {
        menuIsOpen.toggle()
        titleLabel.text = menuIsOpen ? "Select Item!!!!!!!!!!" : "Packing List"
        // Calling layoutIfNeeded() right after changing text label makes it chatch up the text label's boundary change without animation.
        view.layoutIfNeeded()
        
        // Adjust the priority differently in the attribute inspector so that there's no conflict when both constraints are active before the second one deactivates.
        titleCenterYClosedConstraint.isActive = !menuIsOpen
        titleCenterYOpenConstraint.isActive = menuIsOpen

        let constraints = titleLabel.superview!.constraints
        constraints.first {
            // Comparing object references.
            $0.firstItem === titleLabel && $0.firstAttribute == .centerX
        }?.constant = menuIsOpen ? -100 : 0
        
        /*
        You can code a constraints just as below or set an IBOutlet.
        
        // If you deactivate a constraint and don't hold the reference to it, it'll be deleted from memory the next time the layout is updated.
        constraints.first { $0.identifier == "Title Center Y" }!.isActive = false
        // Setting up a new constraint.
        let constraint = NSLayoutConstraint(item: titleLabel!, attribute: .centerY, relatedBy: .equal, toItem: titleLabel.superview, attribute: .centerY, multiplier: menuIsOpen ? 2 / 3 : 1, constant: 0)
        constraint.identifier = "Title Center Y"
        constraint.priority = .defaultHigh
        constraint.isActive = true
        */

        // One call for layoutIfNeeded() inside of the animate method will animate all the constraint changes waiting for an update.
        menuHeightConstraint.constant = menuIsOpen ? 200 : 80
        menuButtonTrailingConstraint.constant = menuIsOpen ? 16 : 8
        
        UIView.animate(
            withDuration: 1, delay: 0,
            usingSpringWithDamping: 0.4, initialSpringVelocity: 10,
            // You can't mix time easing curve with spring animaitons.
            // Be careful with using allowUserInteraction option because it can cause a performance hit.
            options: .allowUserInteraction,
            animations: {
                self.menuButton.transform = .init(rotationAngle: self.menuIsOpen ? .pi / 4 : 0)
                self.view.layoutIfNeeded()
            }
        )
    }
    
    func showItem(_ item: Item) {
        // Setting image view for previewing imoji.
        let imageView = UIImageView(item: item)
        imageView.backgroundColor = .init(white: 0, alpha: 0.5)
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        // If you want to use transition, the views you want to effect should be wrapped in a separate container view or superview.
        let containerView = UIView(frame: imageView.frame)
        view.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: containerView.frame.height)
        let widthConstraint = containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 3, constant: -50)
        
        NSLayoutConstraint.activate([
            bottomConstraint,
            widthConstraint,
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor),

            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            // Constraint that keep the image view in square aspect ratio.
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        // Call layoutIfNeeded() to force auto layout to update so that the layout constraints you defined above can be applied.
        view.layoutIfNeeded()
        
        UIView.animate(
            withDuration: 0.8, delay: 0,
            usingSpringWithDamping: 0.6, initialSpringVelocity: 10,
            // You can't mix time easing curve with spring animaitons.
            options: [],
            animations: {
                bottomConstraint.constant = imageView.frame.height * -2
                widthConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        )
        
        // Pop up the imoji.
        /*UIView.animate(withDuration: 0.8, animations: {
            bottomConstraint.constant = imageView.frame.height * -2
            widthConstraint.constant = 0
            self.view.layoutIfNeeded()
        })*/
        
        // Screen out the poped up imoji.
        /*UIView.animate(
            withDuration: 2 / 3,delay: 1.2,
            animations: {
                bottomConstraint.constant = imageView.frame.height
                widthConstraint.constant = -50
                self.view.layoutIfNeeded()
            },
            completion: {
                // You can define something that you want to execute after the animation executed.
                // In this way, the view hierarchy only holds the image view when it's showing.
                _ in imageView.removeFromSuperview()
            }
        )*/
        delay(seconds: 1, execute: {
            UIView.transition(with: containerView, duration: 1, options: .transitionFlipFromBottom, animations: imageView.removeFromSuperview, completion: { _ in containerView.removeFromSuperview() })
        })
    }
    
    func transitionCloseMenu() {
        delay(seconds: 0.35, execute: toggleMenu)
        
        // Get a hold of the menu and store a reference in a local constant to use as a container view.
        let titleBar = slider.superview!
        UIView.transition(
            with: titleBar,
            duration: 0.5,
            options: .transitionFlipFromBottom,
            animations: { self.slider.isHidden = true },
            // We don't want to permanently hide the slider.
            completion: { _ in self.slider.isHidden = false}
        )
    }
}

private func delay(seconds: TimeInterval, execute: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: execute)
}
