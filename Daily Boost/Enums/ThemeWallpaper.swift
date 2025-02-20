//
//  ThemeWallpaper.swift
//  Daily Boost
//
//  Created by Long Nguyen on 11/5/24.
//

import Foundation

enum ThemeWallpaper: CaseIterable {
    case mostPopular
    case sceneAnimated //like anime
    case season // seasons + xmas + halloween + lunar
    case space
    case beach
    case mountain
    case scene //sunset, sunrise, nature, ecllipse
    case texture
    case plain
    case architecture //eiffel
    
    var name: String {
        switch self {
        case .mostPopular:
            return "Most Popular"
        case .sceneAnimated:
            return "Animated scene"
        case .season:
            return "Season"
        case .plain:
            return "Plain"
        case .beach:
            return "Beach"
        case .mountain:
            return "Mountain"
        case .texture:
            return "Textured"
        case .space:
            return "Space"
        case .architecture:
            return "Architecture"
        case .scene:
            return "Scenary and Objects"
        }
    }
}

/*
 --case mostPopular
 --case sceneAnimated //like anime
 case season // seasons + xmas + halloween + lunar
 --case space
 case beach
 case mountain
 case scene //sunset, sunrise, nature, ecllipse
 case texture
 case plain
 --case architecture //eiffel

 */
