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

final class PopAnimator: NSObject {
    // CGRect with no argument is just a rectangle at the upperleft with no area.
    var originFrame = CGRect()
    var presenting = true
    
    // TimeInterval is just a type alias for double.
    private let duration: TimeInterval = 1

}

// UIViewControllerAnimatedTransitioning protocol is an objective-C protocol.
// Subclass NSObjects since this protocol only works with it.
extension PopAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1. Set up transition.
        // Transition context is a container view (or super view) that grabs all of the views that involves with the transition.
        let containerView = transitionContext.containerView
        
        guard let herbView = transitionContext.view(forKey: presenting ? .to : .from)
        else { return }
        
        // Setting multiple values using tuple.
        let (initialFrame, finalFrame) = presenting ?
            (originFrame, herbView.frame) : (herbView.frame, originFrame)
        
        let scaleTransform = presenting ?
            CGAffineTransform(
                scaleX: initialFrame.width / finalFrame.width,
                y: initialFrame.height / finalFrame.height
            ) :
            .init(
                scaleX: finalFrame.width / initialFrame.width,
                y: finalFrame.height / initialFrame.height
            )
        
        // Set herbView when it's presenting.
        if presenting {
            herbView.transform = scaleTransform
            herbView.center = .init(x: initialFrame.midX, y: initialFrame.midY)
        }
        
        // a property for scaling transform is what scales x value. It's the upper left value of the underlying matrix.
        herbView.layer.cornerRadius = presenting ? 20 / scaleTransform.a : 0
        // Set clips to bounds to true, so that the image applied to that view will respect the rounded corners.
        herbView.clipsToBounds = true

        // You still need to manually add toView to the containerView.
        // Grab the view that will be transited to and add to the containerView.
        if let toView = transitionContext.view(forKey: .to) {
            containerView.addSubview(toView)
        }
        
        // herView must always be the frontmost view.
        containerView.bringSubviewToFront(herbView)
        
        // All the text views in the detail view controller are added to the main view which is connected to the container view outlet. Therefore, you just need to fade in or out the container view to flip the text view's visibility.
        guard let herbDetailsContainer = (transitionContext.viewController(forKey: presenting ? .to : .from) as? HerbDetailsViewController)?.containerView
        else { return }

        if presenting {
            herbDetailsContainer.alpha = 0
        }

        // 2. Animate!
        UIView.animate(
            withDuration: duration, delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0,
            animations: {
                herbView.layer.cornerRadius = self.presenting ? 0: 20 / scaleTransform.a
                herbView.transform = self.presenting ? .identity : scaleTransform
                herbView.center = .init(x: finalFrame.midX, y: finalFrame.midY)
                herbDetailsContainer.alpha = self.presenting ? 1 : 0
            },
            completion: { _ in
                if self.presenting == false {
                    // Grab the view controller of toView to reset the selectedImage's alpha value.
                    (transitionContext.viewController(forKey: .to) as! ViewController).selectedImage.alpha = 1
                }
                transitionContext.completeTransition(true)
            }
        )
    }
}
