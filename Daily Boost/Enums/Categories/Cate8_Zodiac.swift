//
//  Cate8_Zodiac.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/25/24.
//

import Foundation

enum Cate8_Zodiac: CaseIterable {
    case virgo
    case aries
    case libra
    case sagittarius
    case scorpio
    case taurus
    case aquarius
    case capricorn
    case pisces
    case gemini
    case cancer
    case leo
    
    var name: String {
        switch self {
        case .virgo:
            return "Virgo"
        case .aries:
            return "Aries"
        case .libra:
            return "Libra"
        case .sagittarius:
            return "Sagittarius"
        case .scorpio:
            return "Scorpio"
        case .taurus:
            return "Taurus"
        case .aquarius:
            return "Aquarius"
        case .capricorn:
            return "Capricorn"
        case .pisces:
            return "Pisces"
        case .gemini:
            return "Gemini"
        case .cancer:
            return "Cancer"
        case .leo:
            return "Leo"
        }
    }
    
//    var imgStr: String {
//        switch self {
//        case .virgo:
//            <#code#>
//        case .aries:
//            <#code#>
//        case .libra:
//            <#code#>
//        case .sagittarius:
//            <#code#>
//        case .scorpio:
//            <#code#>
//        case .taurus:
//            <#code#>
//        case .aquarius:
//            <#code#>
//        case .capricorn:
//            <#code#>
//        case .pisces:
//            <#code#>
//        case .gemini:
//            <#code#>
//        case .cancer:
//            <#code#>
//        case .leo:
//            <#code#>
//        }
//    }
}
