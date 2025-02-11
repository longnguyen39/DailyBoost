//
//  Cate2_Hard.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/25/24.
//

import Foundation

enum Cate2_Hard: CaseIterable {
    case loneliness
    case heartBroken
    case overFear
    case frustration
    case beStrong
    case overthinking
    case uncertainty
    case missSomeone
    case change
    
    var name: String {
        switch self {
        case .uncertainty:
            return "Uncertainty"
        case .frustration:
            return "Frustration"
        case .missSomeone:
            return "Nostalgia"
        case .heartBroken:
            return "Heartbroken"
        case .overthinking:
            return "Overthinking"
        case .overFear:
            return "Fear"
        case .beStrong:
            return "Be strong"
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
