//
//  CateToggleScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 2/19/25.
//

import SwiftUI

struct CateToggleScreen: View {
    
    @Environment(\.colorScheme) var mode
    @AppStorage(UserDe.show_top_left) var showCateOnTop: Bool?
    @State var showCateTopLeft: Bool = true
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("*Display the quote category on top left corner")
                        .font(.caption)
                        .fontWeight(.regular)
                        .foregroundStyle(.gray)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                Toggle("Show Category", isOn: $showCateTopLeft)
                    .tint(.color3)
                    .fontWeight(.medium)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 0.5)
                    .foregroundStyle(Color(.systemGray4))
                    .shadow(color: .black.opacity(0.4), radius: 2)
            }
            .background(mode == .light ? Color.white : DARK_GRAY)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .onAppear {
                showCateTopLeft = showCateOnTop ?? true
            }
            .onChange(of: showCateTopLeft) {
                UserDefaults.standard.set(showCateTopLeft, forKey: UserDe.show_top_left)
            }
            .sensoryFeedback(.selection, trigger: showCateTopLeft)
            .padding(.horizontal)
            .padding(.top)
            
            Spacer()
        }
        .navigationTitle("Show Category")
    }
}

#Preview {
    CateToggleScreen()
}

