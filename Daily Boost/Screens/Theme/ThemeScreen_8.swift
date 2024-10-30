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
                Text("Ei buddy")
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
