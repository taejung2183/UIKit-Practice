//
//  DataSource.swift
//  RayWenderlichLibrary
//
//  Created by atj on 2021/03/14.
//  Copyright © 2021 Ray Wenderlich. All rights reserved.
//

import Foundation

// Store an array of TutorialCollection values, so define as a stored property.
class DataSource {
    // Expose as a singletone object.
    static let shared = DataSource()

    var tutorials: [TutorialCollection]
    private let decoder = PropertyListDecoder()
    
    // Get a reference to the plist.
    // You don't want this logic happen whenever you create an instance, so private this initializer and expose as a singletone object.
    private init() {
        guard let url = Bundle.main.url(forResource: "Tutorials", withExtension: "plist"),
              // try? -> Use when the job is throwing function. If the job throws error, returns nil.
              let data = try? Data(contentsOf: url),
              // You need to add Decodable conformance to all the models if you want to use decode().
              let tutorials = try? decoder.decode([TutorialCollection].self, from: data) else {
            self.tutorials = []
            return
        }
        
        self.tutorials = tutorials
    }
}
