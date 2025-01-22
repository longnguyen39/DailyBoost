//
//  AllThemeScreen_19.swift
//  Daily Boost
//
//  Created by Long Nguyen on 11/5/24.
//

import SwiftUI

struct AllThemeScreen: View {
    
    let columns = [GridItem(.flexible()),
                   GridItem(.flexible()),
                   GridItem(.flexible())]
    
    var title: String
    @Binding var themeArr: [Theme]
    @Binding var showTheme: Bool
    
    var body: some View {
        VStack {
            Divider().padding(.bottom)
            
            ScrollView(.vertical) {
                LazyVGrid(columns: columns,spacing: 12) {
                    ForEach(themeArr, id: \.self) { theme in
                        ThemeCell(showTheme: $showTheme, isPicked: false, theme: theme)
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle(title)
        .onAppear {
            UserDefaults.standard.set(false, forKey: UserDe.themeNotFetch)
        }
    }
}

#Preview {
    AllThemeScreen(title: "haha", themeArr: .constant(Theme.mockThemeArr), showTheme: .constant(true))
}
