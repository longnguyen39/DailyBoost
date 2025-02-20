//
//  ThemeHScrollV.swift
//  Daily Boost
//
//  Created by Long Nguyen on 11/3/24.
//

import SwiftUI

struct ThemeHScrollV: View {
    
    @AppStorage(UserDe.themeNotFetch) var themeNotFetch: Bool?
    
    var title: String
    @Binding var showTheme: Bool
    @State var displayThemeArr: [Theme] = []
    @State var fullThemeArr: [Theme] = Theme.mockThemeArr
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                Spacer()
                
                NavigationLink {
                    AllThemeScreen(title: title, themeArr: $fullThemeArr, showTheme: $showTheme)
                } label: {
                    Text("View all")
                        .font(.footnote)
                        .fontWeight(.regular)
                        .foregroundStyle(.blue)
                        .padding(.horizontal)
                }

            }
            
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.flexible())], spacing: 8) {
                    ForEach(displayThemeArr, id: \.self) { theme in
                        ThemeCell(showTheme: $showTheme, isPicked: false, theme: theme)
                        
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
            .frame(height: themeCellH + 4)
            .onAppear {
                Task { //themeNotFetch prevents abundant fetch
                    if themeNotFetch ?? true {
                        await fetchThemes()
                    }
                }
            }
        }
    }
    
//MARK: - Function
    
    private func fetchThemes() async {
        do {
            print("DEBUG_24: fetching themeArr \(title)")
            fullThemeArr = try await         ServiceFetch.shared.fetchThemesFromATitle(themeTitle: title).shuffled()
            
            //most pop theme is always the first one
            if title == ThemeWallpaper.mostPopular.name {
                fullThemeArr.insert(Theme.defaultTheme, at: 0)
            }
            
            //display only first 7 themes
            if fullThemeArr.count > 7 {
                displayThemeArr = Array(fullThemeArr.prefix(7))
            } else {
                displayThemeArr = fullThemeArr
            }
        } catch {
            print("DEBUG_24: fail to fetch theme: \(error.localizedDescription)")
        }
    }
    
    
}

#Preview {
    ThemeHScrollV(title: "Season", showTheme: .constant(false))
}
