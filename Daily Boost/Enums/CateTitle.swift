//
//  EnumCate.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/24/24.
//

import Foundation

enum Cate: CaseIterable {
    case zero
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    
    var title: String {
        switch self {
        case .zero:
            return "For you"
        case .one:
            return "Love yourself"
        case .two:
            return "Hard times"
        case .three:
            return "Emotions"
        case .four:
            return "Productivity"
        case .five:
            return "Relationship"
        case .six:
            return "Sport"
        case .seven:
            return "Be Calm"
        case .eight:
            return "Zodiac signs"
        }
    }
}

