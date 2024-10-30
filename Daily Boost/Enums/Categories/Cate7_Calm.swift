//
//  Cate3_Calm.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/25/24.
//

import Foundation

enum Cate7_Calm: CaseIterable {
    case sleep
    case calm
    case anxiety
    case perseverance
    case stress
    case smile
    case creative
    
    var name: String {
        switch self {
        case .sleep:
            return "Sleep"
        case .calm:
            return "Calm"
        case .anxiety:
            return "Anxiety"
        case .perseverance:
            return "Perseverance"
        case .stress:
            return "Stress"
        case .smile:
            return "Smile"
        case .creative:
            return "Creativity"
        }
    }
    
//    var imgStr: String {
//        switch self {
//        case .sleep:
//            <#code#>
//        case .calm:
//            <#code#>
//        case .anxiety:
//            <#code#>
//        case .peaceMind:
//            <#code#>
//        case .patience:
//            <#code#>
//        case .stress:
//            <#code#>
//        case .smile:
//            <#code#>
//        case .creative:
//            <#code#>
//        }
//    }
}
