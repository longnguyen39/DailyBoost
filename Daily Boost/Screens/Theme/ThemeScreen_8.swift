//
//  ThemeScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/26/24.
//

import SwiftUI

struct ThemeScreen: View {
    
    @Binding var showTheme: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical) {
                    HStack {
                        ThemeCell(showTheme: $showTheme, isPicked: true, theme: Theme.mockThemeArr[0])
                            .frame(width: themeCellW, height: themeCellH)
                            .padding()
                        Spacer()
                    }
                    
                    ForEach(ThemeWallpaper.allCases, id: \.self) { theme in
                        ThemeHScrollV(title: theme.name, showTheme: $showTheme)
                            .padding(.bottom, 12)
                    }
                }
                
            }
            .navigationTitle("Theme")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showTheme.toggle()
                    } label: {
                        Image(systemName: "chevron.down")
                            .imageScale(.large)
                            .fontWeight(.semibold)
                    }

                }
            }
        }
    }
}

#Preview {
    ThemeScreen(showTheme: .constant(true))
}
