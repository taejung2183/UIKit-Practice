//
//  BadgeSupplementaryView.swift
//  RayWenderlichLibrary
//
//  Created by atj on 2021/03/19.
//  Copyright © 2021 Ray Wenderlich. All rights reserved.
//

import UIKit

final class BadgeSupplementaryView: UICollectionReusableView {
    static let reuseIdentifier = String(describing: BadgeSupplementaryView.self)
    
    // Since this is a view defined in code, we need to add an initilizer.
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        backgroundColor = UIColor(named: "rw-green")
        let radius = bounds.width / 2.0
        layer.cornerRadius = radius
    }
}
