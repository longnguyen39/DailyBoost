//
//  FictionOption.swift
//  Daily Boost
//
//  Created by Long Nguyen on 1/9/25.
//

import Foundation

enum FictionOption: CaseIterable, Decodable {
    case fiction
    case nonFiction
    case both
    
    var name: String {
        switch self {
        case .fiction:
            return "Fictional quotes"
        case .nonFiction:
            return "Non-fictional quotes"
        case .both:
            return "Mix both"
        }
    }
}
