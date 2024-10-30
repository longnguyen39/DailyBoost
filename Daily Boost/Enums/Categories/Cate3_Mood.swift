//
//  Cate1_Mood.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/25/24.
//

import Foundation

enum Cate3_Mood: CaseIterable {
    case sad
    case neutral
    case happy
    case relax
    case depress
    case grief
    case excited
    case angry
    
    var name: String {
        switch self {
        case .sad:
            return "Sad"
        case .neutral:
            return "Neutral"
        case .happy:
            return "Happy"
        case .relax:
            return "Relax"
        case .depress:
            return "Depress"
        case .grief:
            return "Grief"
        case .excited:
            return "Excited"
        case .angry:
            return "Angry"
        }
    }
}
