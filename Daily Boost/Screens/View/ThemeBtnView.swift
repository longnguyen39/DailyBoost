//
//  RecBtnView.swift
//  Daily Boost
//
//  Created by Long Nguyen on 1/13/25.
//

import SwiftUI

struct ThemeBtnView: View {
    
    var context: String
    var foreC: Color = .white
    
    var body: some View {
        Text(context)
            .font(.headline)
            .foregroundStyle(foreC)
            .frame(width: UIScreen.width-32, height: 48)
            .background(
                LinearGradient(gradient: Gradient(colors: [.c1, .c2, .c3, .c4, .c5]), startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
    }
}

#Preview {
    ThemeBtnView(context: "ahha")
}
