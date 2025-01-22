//
//  Theme.swift
//  Daily Boost
//
//  Created by Long Nguyen on 11/5/24.
//

import SwiftUI

struct Theme: Codable, Hashable {
    var fileName: String
    var isDarkText: String
    var title: String
    
    static var mockThemeArr: [Theme] = [
        .init(fileName: "", isDarkText: "false", title: "Space"),
        .init(fileName: "", isDarkText: "false", title: "Space"),
        .init(fileName: "", isDarkText: "false", title: "Space")
    ]
    
    static var defaultTheme: Theme = Theme(fileName: "default", isDarkText: "false", title: ThemeWallpaper.mostPopular.name)
    
}
