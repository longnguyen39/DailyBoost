//
//  Cate2_Hard.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/25/24.
//

import Foundation

enum Cate2_Hard: CaseIterable {
    case overthinking
    case uncertainty
    case frustration
    case missSomeone
    case heartBroken
    case overFear
    case beStrong
    case change
    case loneliness
    
    var name: String {
        switch self {
        case .overthinking:
            return "Overthinking"
        case .uncertainty:
            return "Uncertainty"
        case .frustration:
            return "Frustration"
        case .missSomeone:
            return "Nostalgia"
        case .heartBroken:
            return "Heartbroken"
        case .overFear:
            return "Fear"
        case .beStrong:
            return "Be_strong"
        case .change:
            return "Adaptation"
        case .loneliness:
            return "Loneliness"
        }
    }
    
//    var imgStr: String {
//        switch self {
//        case .overthinking:
//            <#code#>
//        case .uncertainty:
//            <#code#>
//        case .frustration:
//            <#code#>
//        case .missSomeone:
//            <#code#>
//        case .heartBroken:
//            <#code#>
//        case .overFear:
//            <#code#>
//        case .beStrong:
//            <#code#>
//        case .change:
//            <#code#>
//        case .loneliness:
//            <#code#>
//        }
//    }
}
