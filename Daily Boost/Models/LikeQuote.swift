//
//  LikeQuote.swift
//  Daily Boost
//
//  Created by Long Nguyen on 1/20/25.
//

import UIKit

struct LikeQuote: Codable, Hashable { //Hashable when used in ForEach
    
    var script: String
    var catePath: String
    var author: String
    var timeStamp: Date
            
    static var mockData: LikeQuote = LikeQuote(script: "Hahahah", catePath: "dumbass", author: "NoobMaster69", timeStamp: Date.now)
    
}
