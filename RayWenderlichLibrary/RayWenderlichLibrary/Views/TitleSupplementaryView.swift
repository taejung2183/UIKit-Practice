//
//  TitleSupplementaryView.swift
//  RayWenderlichLibrary
//
//  Created by atj on 2021/03/15.
//  Copyright © 2021 Ray Wenderlich. All rights reserved.
//

import UIKit

// Implement a supplementary view in code so that you can use it in multiple views.
final class TitleSupplementaryView: UICollectionReusableView {
    static let reuseIdentifier = String(describing: TitleSupplementaryView.self)
    
    let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    // When instances of UIView are initialized from storyboard the init coder initializer is called. This is a required initializer, so you need to add it to the subclass.
    // But we're not actually going to use this initializer.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    // Call this method when the view is created. Call this in init(frame:) initializer.
    private func configure() {
        addSubview(textLabel)
        textLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Setting up auto layout constraints.
        let inset: CGFloat = 10
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
        ])
    }
}
