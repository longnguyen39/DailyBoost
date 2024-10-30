//
//  Cate6_Sport.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/25/24.
//

import Foundation

enum Cate6_Sport: CaseIterable {
    case health
    case competition
    case weightLoss
    case gym
    case run
    case excuse
    case grinding
    case giveup
    case recovery
    
    var name: String {
        switch self {
        case .health:
            return "Health"
        case .competition:
            return "competition"
        case .weightLoss:
            return "Weight loss"
        case .gym:
            return "Gym"
        case .run:
            return "Run"
        case .excuse:
            return "No excuse"
        case .grinding:
            return "Grinding"
        case .giveup:
            return "Never give up"
        case .recovery:
            return "Recovery"
        }
    }
    
//    var imgStr: String {
//        switch self {
//        case .health:
//            <#code#>
//        case .competition:
//            <#code#>
//        case .weightLoss:
//            <#code#>
//        case .gym:
//            <#code#>
//        case .run:
//            <#code#>
//        case .excuse:
//            <#code#>
//        case .grinding:
//            <#code#>
//        case .giveup:
//            <#code#>
//        case .recovery:
//            <#code#>
//        }
//    }
}
